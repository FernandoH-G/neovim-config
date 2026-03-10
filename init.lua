-- bread's neovim config
-- Now FHs!
-- keymaps are in lua/config/mappings.lua
-- install a patched font & ensure your terminal supports glyphs
-- enjoy :D

-- auto install vim-plug and plugins, if not found
local data_dir = vim.fn.stdpath('data')
if vim.fn.empty(vim.fn.glob(data_dir .. '/site/autoload/plug.vim')) == 1 then
	vim.cmd('silent !curl -fLo ' .. data_dir .. '/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
	vim.o.runtimepath = vim.o.runtimepath
	vim.cmd('autocmd VimEnter * PlugInstall --sync | source $MYVIMRC')
end

local vim = vim
local Plug = vim.fn['plug#']

vim.g.start_time = vim.fn.reltime()
vim.loader.enable() --  SPEEEEEEEEEEED 
vim.call('plug#begin')

Plug("rebelot/kanagawa.nvim")
Plug("akinsho/toggleterm.nvim")
Plug('nvim-lualine/lualine.nvim') --statusline
Plug('nvim-tree/nvim-web-devicons') --pretty icons
Plug('goolord/alpha-nvim') --pretty startup
Plug('nvim-treesitter/nvim-treesitter') --improved syntax
Plug('mfussenegger/nvim-lint') --async linter
Plug('nvim-tree/nvim-tree.lua') --file explorer
Plug('windwp/nvim-autopairs') --autopairs 
Plug('lewis6991/gitsigns.nvim') --git
Plug('numToStr/Comment.nvim') --easier comments
Plug('norcalli/nvim-colorizer.lua') --color highlight
Plug('ibhagwan/fzf-lua') --fuzzy finder and grep
Plug('ron-rs/ron.vim') --ron syntax highlighting
Plug('MeanderingProgrammer/render-markdown.nvim') --render md inline
Plug('emmanueltouzery/decisive.nvim') --view csv files
Plug('folke/twilight.nvim') --surrounding dim
-- Plug('catppuccin/nvim', { ['as'] = 'catppuccin' }) --colorscheme

vim.call('plug#end')
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

-- vim.defer_fn(function() 
-- 		--defer non-essential configs,
-- 		--purely for experimental purposes:
-- 		--this only makes a difference of +-10ms on initial startup
-- end, 100)

vim.lsp.enable('ts-lsp')
vim.cmd[[set completeopt+=noselect]]
vim.cmd("colorscheme kanagawa-dragon")
-- vim.cmd[[set completeopt+=menuone,noselect,popup]]
-- vim.cmd[[set shortmess+=c]]

