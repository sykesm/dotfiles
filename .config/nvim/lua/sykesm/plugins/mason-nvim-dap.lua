-- mason-nvim-dap.lua

local M = {
  'jay-babu/mason-nvim-dap.nvim',
  dependencies = {
    'mason-org/mason.nvim',
  },
  lazy = true,
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
