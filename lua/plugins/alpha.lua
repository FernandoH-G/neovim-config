local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")
dashboard.section.header.val = {

	[[ *************************************************** ]],
	[[ ******************************************** /|\*** ]],
	[[ ****************************************** /|\/|\ * ]],
	[[ ******/|\**********--------**************/|\ /|\/|\ ]],
}

dashboard.section.buttons.val = {
	dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("f", "󰍉  Find file", ":lua require('fzf-lua').files() <CR>"),
	dashboard.button("b", "  Browse cwd", ":NvimTreeOpen<CR>"),
	dashboard.button("c", "  Config", ":e ~/.config/nvim/<CR>"),
	dashboard.button("m", "  Mappings", ":e ~/.config/nvim/lua/config/mappings.lua<CR>"),
	dashboard.button("p", "  Plugins", ":PlugInstall<CR>"),
	dashboard.button("q", "󰅙  Quit", ":q!<CR>"),
}

dashboard.section.footer.val = function()
	return vim.g.startup_time_ms or "[[ FH-G ]]"
end

dashboard.section.buttons.opts.hl = "Keyword"
dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
