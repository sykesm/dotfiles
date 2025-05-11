-- mason-lspconfig.lua

local M = {
  'mason-org/mason-lspconfig.nvim', -- mason extensions for LSPs
  dependencies = { 'mason-org/mason.nvim' },
  lazy = true,
}

function M.config()
  local servers = require('sykesm.lsp.servers')
  local mason_lspconfig = require('mason-lspconfig')

  mason_lspconfig.setup({
    automatic_enable = {
      exclude = {
        'jdtls',
        'ts_ls',
      },
    },
    ensure_installed = vim.tbl_keys(servers),
  })
end

return M
