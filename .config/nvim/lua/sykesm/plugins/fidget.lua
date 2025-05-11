-- fidget.lua

-- Useful status updates for LSP
return {
  'j-hui/fidget.nvim',
  version = '^2.0.0',
  lazy = true,
  opts = {
    integration = {
      ['nvim-tree'] = {
        enable = false,
      },
    },
  },
}
