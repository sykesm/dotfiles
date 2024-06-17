-- keymaps.lua

-- space clears search string highlighting
vim.keymap.set('n', '<space>', ':nohl<cr><space>', { noremap = true, silent = true })

-- shrug ¯\_(ツ)_/¯ - ctrl-o<leader>S while in insert mode
vim.keymap.set('n', '<leader>S', 'i¯\\_(ツ)_/¯<esc>', { noremap = true })

-- make Y consistent with C and D
vim.keymap.set('n', 'Y', 'y$', { noremap = true })

-- <control>-{hjkl} to change active window
vim.keymap.set('n', '<c-h>', '<c-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<c-j>', '<c-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<c-k>', '<c-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<c-l>', '<c-w>l', { noremap = true, silent = true })

-- close all but the current window
vim.keymap.set('n', '<leader>o', ':only<cr>', { noremap = true })

-- macOS dictionary
if vim.fn.has('macunix') then
  vim.keymap.set('n', '<leader>D', ':!open dict://<cword><cr><cr>')
end

-- Terminal settings
-- switch to normal mode with esc
vim.keymap.set('t', '<esc>', '<c-\\><c-n>', { noremap = true })

-- mappings to move out from terminal to other views
vim.keymap.set('t', '<m-h>', '<c-\\><c-n><c-w>h', { noremap = true })
vim.keymap.set('t', '<m-j>', '<c-\\><c-n><c-w>j', { noremap = true })
vim.keymap.set('t', '<m-k>', '<c-\\><c-n><c-w>k', { noremap = true })
vim.keymap.set('t', '<m-l>', '<c-\\><c-n><c-w>l', { noremap = true })
