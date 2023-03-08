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
        ['o'] = {
          command = function(state)
            if vim.fn.has('macunix') then
              local node = state.tree:get_node()
              vim.cmd('silent! !open file://' .. node.path)
            end
          end,
          nowait = true,
        },
      },
    },
  },
})

vim.keymap.set('', '<leader>n', ':Neotree toggle<cr>', { noremap = true })
vim.keymap.set('', '<F9>', ':Neotree reveal<cr>', { noremap = true })

local title_fg = string.format('#%06x', vim.api.nvim_get_hl_by_name('BufferVisible', true)['foreground'])

vim.cmd([[highlight NeoTreeNormal guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight! link NeoTreeDotfile NonText]])
vim.cmd([[highlight NeoTreeTitleBar guifg=]] .. title_fg)
