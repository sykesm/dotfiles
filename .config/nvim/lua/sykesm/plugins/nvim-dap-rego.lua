-- nvim-dap-rego.lua

local M = {
  'rinx/nvim-dap-rego',
  dependencies = {
    'mfussenegger/nvim-dap',
  },
  opts = {
    regal = {
      path = require('sykesm.lsp.regal').regal_path(),
      args = { 'debug' },
    },
  },
  ft = {
    'rego',
  },
}

return M
