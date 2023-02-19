-- neo-tree.lua

local neo_tree_ok, neo_tree = pcall(require, 'neo-tree')
if not neo_tree_ok then
  return
end

vim.g.neo_tree_remove_legacy_commands = 1
neo_tree.setup({
  window = {
    mappings = {
      ['l'] = 'noop',
      ['Z'] = 'expand_all_nodes',
    },
  },
  filesystem = {
    window = {
      mappings = {
        ['C'] = 'set_root',
      },
    },
  },
})

vim.keymap.set('', '<leader>n', ':Neotree toggle<cr>', { noremap = true })
vim.keymap.set('', '<F9>', ':Neotree reveal<cr>', { noremap = true })

vim.cmd([[highlight NeoTreeNormal guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight! link NeoTreeDotfile NonText]])
