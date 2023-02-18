-- neo-tree.lua

local neo_tree_ok, neo_tree = pcall(require, 'neo-tree')
if not neo_tree_ok then
  return
end

vim.g.neo_tree_remove_legacy_commands = 1
neo_tree.setup({})

vim.keymap.set('', '<leader>n', ':Neotree toggle<cr>', { noremap = true })
vim.keymap.set('', '<F9>', ':Neotree file<cr>', { noremap = true })
