-- nerdtree.lua

vim.keymap.set('', '<leader>n', ':NERDTreeToggle<cr>', { noremap = true })
vim.keymap.set('', '<F9>', ':NERDTreeFind<cr>', { noremap = true })

vim.g.NERDTreeShowBookmarks = 1
vim.g.NERDTreeShowHidden = 1
