-- fidget.lua

return {
  'j-hui/fidget.nvim',
  version = '~1.4.1', -- Useful status updates for LSP
  event = 'VeryLazy',
  opts = {
    integration = {
      ['nvim-tree'] = {
        enable = false,
      },
    },
  },
}
