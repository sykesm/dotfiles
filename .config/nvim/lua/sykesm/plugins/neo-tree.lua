-- neo-tree.lua

local M = {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  cmd = 'Neotree',
  keys = {
    { '<leader>n', '<cmd>Neotree toggle<cr>', desc = 'Toggle NeoTree' },
    { '<F9>', '<cmd>Neotree reveal<cr>', desc = 'Show file in NeoTree' },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- optional, for file icons
    'MunifTanjim/nui.nvim',
  },
  opts = {
    default_component_configs = {
      icon = {
        folder_empty = '󰜌',
        folder_empty_open = '󰜌',
      },
      git_status = {
        symbols = {
          renamed = '󰁕',
          unstaged = '󰄱',
        },
      },
      diagnostics = {
        symbols = {
          hint = '󰌶', -- lightbulb_outline
          info = '', -- nf-oct-info
          warn = '󰀪', -- alert_outline
          error = '󰅚', -- close_circle_outline
        },
      },
    },
    document_symbols = {
      kinds = {
        File = { icon = '󰈙', hl = 'Tag' },
        Namespace = { icon = '󰌗', hl = 'Include' },
        Package = { icon = '󰏖', hl = 'Label' },
        Class = { icon = '󰌗', hl = 'Include' },
        Property = { icon = '󰆧', hl = '@property' },
        Enum = { icon = '󰒻', hl = '@number' },
        Function = { icon = '󰊕', hl = 'Function' },
        String = { icon = '󰀬', hl = 'String' },
        Number = { icon = '󰎠', hl = 'Number' },
        Array = { icon = '󰅪', hl = 'Type' },
        Object = { icon = '󰅩', hl = 'Type' },
        Key = { icon = '󰌋', hl = '' },
        Struct = { icon = '󰌗', hl = 'Type' },
        Operator = { icon = '󰆕', hl = 'Operator' },
        TypeParameter = { icon = '󰊄', hl = 'Type' },
        StaticMethod = { icon = '󰠄 ', hl = 'Function' },
      },
    },
    sources = {
      'filesystem',
      'buffers',
      'git_status',
      'document_symbols',
    },
    source_selector = {
      sources = {
        { source = 'filesystem' },
        { source = 'buffers' },
        { source = 'document_symbols' },
      },
    },
    filesystem = {
      group_empty_dirs = true,
      scan_mode = 'deep',
      window = {
        mappings = {
          ['C'] = 'set_root',
          ['O'] = {
            command = function(state)
              if vim.fn.has('macunix') then
                local node = state.tree:get_node()
                vim.cmd('silent! !open file://' .. node.path)
              end
            end,
            desc = 'open with associated application',
            nowait = true,
          },
        },
      },
    },
    window = {
      mappings = {
        ['/'] = 'noop',
        ['l'] = 'noop',
        ['Z'] = 'expand_all_nodes',
      },
    },
  },
}

function M.config(_, opts)
  vim.g.neo_tree_remove_legacy_commands = 1
  require('neo-tree').setup(opts)

  vim.cmd([[highlight NeoTreeNormal guibg=NONE ctermbg=NONE]])
  vim.cmd([[highlight! link NeoTreeDotfile NonText]])
end

return M
