-- mason-null-ls.lua

local M = {
  'jay-babu/mason-null-ls.nvim', -- bridges gap between mason & null-ls
  dependencies = {
    'williamboman/mason.nvim',
    'nvimtools/none-ls.nvim',
  },
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    automatic_installation = false,
    ensure_installed = {
      'stylua', -- lua formatter
    },
    handlers = {},
  },
}

function M.config(_, opts)
  require('mason-null-ls').setup(opts)
  require('null-ls').setup()
end

return M
