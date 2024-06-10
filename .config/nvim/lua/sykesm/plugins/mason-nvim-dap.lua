-- mason-nvim-dap.lua

local M = {
  'jay-babu/mason-nvim-dap.nvim',
  dependencies = {
    'williamboman/mason.nvim',
    'mfussenegger/nvim-dap',
  },
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    ensure_installed = {
      'javadbg',
      'javatest',
    },
    handlers = {},
  },
}

function M.config(_, opts)
  require('mason-nvim-dap').setup(opts)
end

return M
