-- fidget.lua

-- Useful status updates for LSP
return {
  'j-hui/fidget.nvim',
  version = '~1.4.1',
  lazy = true,
  opts = {
    integration = {
      ['nvim-tree'] = {
        enable = false,
      },
    },
  },
}
