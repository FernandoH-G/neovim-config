require("nvim-tree").setup({
renderer = {
--note on icons:
--in some terminals, some patched fonts cut off glyphs if not given extra space
--either add extra space, disable icons, or change font
	icons = {
		show = {
		file = false,
		folder = false,
		folder_arrow = true,
		git = true,
		},
	},
},
	view = {
		width = 25,
		side = 'left',
	},
    --fix to open cwd with tree
	sync_root_with_cwd = true,
	respect_buf_cwd = true,
	update_cwd = true,
	update_focused_file = {
		enable = true,
		update_cwd = true,
		update_root = true,
	},
})

vim.g.nvim_tree_respect_buf_cwd = 1
