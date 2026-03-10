-- bread's neovim config
-- Now FHs!
-- keymaps are in lua/config/mappings.lua
-- install a patched font & ensure your terminal supports glyphs
-- enjoy :D

-- auto install vim-plug and plugins, if not found
local vim = vim

local data_dir = vim.fn.stdpath("data")
if vim.fn.empty(vim.fn.glob(data_dir .. "/site/autoload/plug.vim")) == 1 then
	vim.cmd(
		"silent !curl -fLo "
			.. data_dir
			.. "/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
	)
	vim.o.runtimepath = vim.o.runtimepath
	vim.cmd("autocmd VimEnter * PlugInstall --sync | source $MYVIMRC")
end

vim.g.start_time = vim.fn.reltime()
vim.loader.enable() --  SPEEEEEEEEEEED 
vim.call("plug#begin")

local Plug = vim.fn["plug#"]
Plug("rebelot/kanagawa.nvim")
Plug("akinsho/toggleterm.nvim")
Plug("nvim-lualine/lualine.nvim") --statusline
Plug("nvim-tree/nvim-web-devicons") --pretty icons
Plug("goolord/alpha-nvim") --pretty startup
Plug("nvim-treesitter/nvim-treesitter") --improved syntax
Plug("mfussenegger/nvim-lint") --async linter
Plug("nvim-tree/nvim-tree.lua") --file explorer
Plug("windwp/nvim-autopairs") --autopairs
Plug("lewis6991/gitsigns.nvim") --git
Plug("numToStr/Comment.nvim") --easier comments
Plug("norcalli/nvim-colorizer.lua") --color highlight
Plug("ibhagwan/fzf-lua") --fuzzy finder and grep
Plug("ron-rs/ron.vim") --ron syntax highlighting
Plug("MeanderingProgrammer/render-markdown.nvim") --render md inline
Plug("emmanueltouzery/decisive.nvim") --view csv files
Plug("folke/twilight.nvim") --surrounding dim
Plug("neovim/nvim-lspconfig")
Plug("mason-org/mason.nvim")
Plug("creativenull/efmls-configs-nvim")
Plug("saghen/blink.cmp", { ["tag"] = "v1.*" })
-- Plug('catppuccin/nvim', { ['as'] = 'catppuccin' }) --colorscheme
vim.call("plug#end")
-- move config and plugin config to alternate files
require("config.mappings")
require("config.options")
require("config.autocmd")
require("plugins.alpha")
require("plugins.colorizer")
require("plugins.comment")
require("plugins.gitsigns")
require("plugins.lualine")
require("plugins.nvim-lint")
require("plugins.render-markdown")
require("plugins.autopairs")
require("plugins.fzf-lua")
require("plugins.nvim-tree")
require("plugins.treesitter")
require("plugins.twilight")
require("plugins.toggleterm")

require("mason").setup({})
require("blink.cmp").setup({
	-- keymap = {
	-- 	preset = "none",
	-- 	["<C-Space>"] = { "show", "hide" },
	-- 	["<CR>"] = { "accept", "fallback" },
	-- 	["<C-j>"] = { "select_next", "fallback" },
	-- 	["<C-k>"] = { "select_prev", "fallback" },
	-- 	["<Tab>"] = { "snippet_forward", "fallback" },
	-- 	["<S-Tab>"] = { "snippet_backward", "fallback" },
	-- },
	completion = { menu = { auto_show = true } },
	sources = { default = { "lsp", "path", "buffer" } },
})

-- vim.defer_fn(function()
-- 		--defer non-essential configs,
-- 		--purely for experimental purposes:
-- 		--this only makes a difference of +-10ms on initial startup
-- end, 100)

-- vim.lsp.enable('ts-lsp')

--vim.cmd([[set completeopt+=noselect]])
vim.cmd("colorscheme kanagawa-dragon")
-- vim.cmd[[set completeopt+=menuone,noselect,popup]]

-- Format on save (ONLY real file buffers, ONLY when efm is attached)
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = {
		"*.lua",
		"*.go",
		"*.js",
		"*.jsx",
		"*.ts",
		"*.tsx",
		"*.json",
		"*.css",
		"*.scss",
		"*.html",
	},
	callback = function(args)
		-- avoid formatting non-file buffers (helps prevent weird write prompts)
		if vim.bo[args.buf].buftype ~= "" then
			return
		end
		if not vim.bo[args.buf].modifiable then
			return
		end
		if vim.api.nvim_buf_get_name(args.buf) == "" then
			return
		end

		local has_efm = false
		for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
			if c.name == "efm" then
				has_efm = true
				break
			end
		end
		if not has_efm then
			return
		end

		pcall(vim.lsp.buf.format, {
			bufnr = args.buf,
			timeout_ms = 2000,
			filter = function(c)
				return c.name == "efm"
			end,
		})
	end,
})

local diagnostic_signs = {
	Error = " ",
	Warn = " ",
	Hint = "",
	Info = "",
}

vim.diagnostic.config({
	virtual_text = { prefix = "●", spacing = 4 },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
			[vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
			[vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
			[vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
		focusable = false,
		style = "minimal",
	},
})

do
	local orig = vim.lsp.util.open_floating_preview
	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or "rounded"
		return orig(contents, syntax, opts, ...)
	end
end

local function lsp_on_attach(ev)
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then
		return
	end
	client.server_capabilities.semanticTokensProvider = nil

	local bufnr = ev.buf
	local opts = { silent = true, buffer = bufnr }

	-- vim.keymap.set("n", "<leader>gd", function()
	-- 	require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
	-- end, opts)

	vim.keymap.set("n", "<leader>gD", vim.lsp.buf.definition, opts)

	vim.keymap.set("n", "<leader>gS", function()
		vim.cmd("vsplit")
		vim.lsp.buf.definition()
	end, opts)

	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

	vim.keymap.set("n", "<leader>D", function()
		vim.diagnostic.open_float({ scope = "line" })
	end, opts)
	vim.keymap.set("n", "<leader>d", function()
		vim.diagnostic.open_float({ scope = "cursor" })
	end, opts)
	vim.keymap.set("n", "<leader>nd", function()
		vim.diagnostic.jump({ count = 1 })
	end, opts)

	vim.keymap.set("n", "<leader>pd", function()
		vim.diagnostic.jump({ count = -1 })
	end, opts)

	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

	-- vim.keymap.set("n", "<leader>fd", function()
	-- 	require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
	-- end, opts)
	-- vim.keymap.set("n", "<leader>fr", function()
	-- 	require("fzf-lua").lsp_references()
	-- end, opts)
	-- vim.keymap.set("n", "<leader>ft", function()
	-- 	require("fzf-lua").lsp_typedefs()
	-- end, opts)
	-- vim.keymap.set("n", "<leader>fs", function()
	-- 	require("fzf-lua").lsp_document_symbols()
	-- end, opts)
	-- vim.keymap.set("n", "<leader>fw", function()
	-- 	require("fzf-lua").lsp_workspace_symbols()
	-- end, opts)
	-- vim.keymap.set("n", "<leader>fi", function()
	-- 	require("fzf-lua").lsp_implementations()
	-- end, opts)

	if client:supports_method("textDocument/codeAction", bufnr) then
		vim.keymap.set("n", "<leader>oi", function()
			vim.lsp.buf.code_action({
				context = { only = { "source.organizeImports" }, diagnostics = {} },
				apply = true,
				bufnr = bufnr,
			})
			vim.defer_fn(function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end, 50)
		end, opts)
	end
end
vim.api.nvim_create_autocmd("LspAttach", { group = augroup, callback = lsp_on_attach })

vim.lsp.config["*"] = {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
}
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			telemetry = { enable = false },
		},
	},
})
vim.lsp.config("ts_ls", {})

do
	local stylua = require("efmls-configs.formatters.stylua")
	local luacheck = require("efmls-configs.linters.luacheck")

	local prettier_d = require("efmls-configs.formatters.prettier_d")
	local eslint_d = require("efmls-configs.linters.eslint_d")

	local fixjson = require("efmls-configs.formatters.fixjson")

	local go_revive = require("efmls-configs.linters.go_revive")
	local gofumpt = require("efmls-configs.formatters.gofumpt")

	vim.lsp.config("efm", {
		filetypes = {
			"css",
			"go",
			"html",
			"javascript",
			"javascriptreact",
			"json",
			"jsonc",
			"lua",
			"markdown",
			"typescript",
			"typescriptreact",
		},
		init_options = { documentFormatting = true },
		settings = {
			languages = {
				go = { gofumpt, go_revive },
				css = { prettier_d },
				html = { prettier_d },
				javascript = { eslint_d, prettier_d },
				javascriptreact = { eslint_d, prettier_d },
				json = { eslint_d, fixjson },
				jsonc = { eslint_d, fixjson },
				lua = { luacheck, stylua },
				markdown = { prettier_d },
				typescript = { eslint_d, prettier_d },
				typescriptreact = { eslint_d, prettier_d },
			},
		},
	})
end

vim.lsp.enable({
	"lua_ls",
	"ts_ls",
	"gopls",
	"efm",
})
