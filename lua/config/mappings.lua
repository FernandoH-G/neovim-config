-- Mappings
local function map(m, k, v)
	vim.keymap.set(m, k, v, { silent = true })
end

local api = require("Comment.api")

-- Set leader
map("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

map("i", "jk", "<Esc>")
map("n", "<C-x>", "<C-u>")
vim.keymap.set("i", "<C-_>", api.toggle.linewise.current)

-- Toggle nvim tree
-- Not sure why <C-S-s> doesn't work.
map("n", "<leader>e", ":NvimTreeToggle<CR>")

-- buffers
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")
map("n", "<leader>q", ":bp<bar>sp<bar>bn<bar>bd<CR>")

-- vsplit current buffer and 'move' it to the right.
-- Current window changes to the previous buffer.
-- Move focus to the new window/buffer.
map("n", "<leader>vs", ":vsplit<CR>:bprev<CR><CMD>wincmd l<CR>")

-- windows - ctrl nav
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- fzf and grep
map("n", "<C-p>", ":lua require('fzf-lua').files()<CR>") --search cwd
map("n", "<leader>fh", ":lua require('fzf-lua').files({ cwd = '~/' })<CR>") --search home
map("n", "<leader>Fr", ":lua require('fzf-lua').resume()<CR>") --last search
map("n", "<leader>g", ":lua require('fzf-lua').grep()<CR>") --grep
map("n", "<leader>G", ":lua require('fzf-lua').grep_cword()<CR>") --grep word under cursor

-- Terminal stuff
map("n", "<C-t>", ":ToggleTerm<CR>")
map("t", "<C-t>", "<C-\\><C-n><CMD>:ToggleTerm<CR>")
map("t", "<Esc>", "<C-\\><C-n>")

-- Clear search result highlights.
map("n", "<leader>l", ":noh<CR>")

-- Unmap
-- map('n','s', "")
