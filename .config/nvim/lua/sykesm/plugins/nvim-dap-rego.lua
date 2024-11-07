-- nvim-dap-rego.lua

local M = {
  'rinx/nvim-dap-rego',
  dependencies = {
    'mfussenegger/nvim-dap',
  },
  opts = function(_, _)
    return {
      regal = {
        path = require('sykesm.lsp.regal').regal_path(),
        args = { 'debug' },
      },
    }
  end,
  ft = {
    'rego',
  },
}

return M
