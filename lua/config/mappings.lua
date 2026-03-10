-- mappings, including plugins

local function map(m, k, v)
	-- vim.keymap.set(m, k, v, { noremap = true, silent = true })
	vim.keymap.set(m, k, v, { silent = true })
end

local api = require('Comment.api')


-- set leader
map("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- unmap
map('n','s', "")
map('n','S', "")

map("i", "jk", "<Esc>")
map("n", "<C-x>", "<C-u>")
vim.keymap.set('i', '<C-_>', api.toggle.linewise.current)

-- toggle nvim tree 
-- Not sure why <C-S-s> doesn't work.
map('n', '<leader>e', ':NvimTreeToggle<CR>')


-- buffers
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")
map("n", "<leader>q", ":bd<CR>")
--ver split current buffer + move to the new window.
map('n', '<leader>vs', ':vsplitCR><CMD>wincmd l<CR>')

-- buffer position nav + reorder
-- map('n', '<AS-h>', '<Cmd>BufferMovePrevious<CR>')
-- map('n', '<AS-l>', '<Cmd>BufferMoveNext<CR>')
-- map('n', '<A-p>', '<Cmd>BufferPin<CR>')

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
-- map("n", "<leader>Fc", ":lua require('fzf-lua').files({ cwd = '~/.config' })<CR>") --search .config
-- map("n", "<leader>Fl", ":lua require('fzf-lua').files({ cwd = '~/.local/src' })<CR>") --search .local/src
-- map("n", "<leader>Ff", ":lua require('fzf-lua').files({ cwd = '..' })<CR>") --search above

-- terminal stuff
map('n', '<leader>t', ":ToggleTerm<CR>")
map('t', '<leader>t', '<C-\\><C-n><CMD>:ToggleTerm<CR>')
map('t', "<Esc>", "<C-\\><C-n>")

-- lsp
vim.keymap.set('i', '<c-space>', function()
    vim.lsp.completion.get()
end)
vim.keymap.set('i', '<leader>s', function()
    vim.lsp.buf.signature_help()
end)
-- Clear search result highlights.
map('n', "<leader>l", ":noh<CR>")
-- vim.keymap.set("i", "<C-space>", vim.lsp.completion.get, { desc = "trigger autocompletion" })

