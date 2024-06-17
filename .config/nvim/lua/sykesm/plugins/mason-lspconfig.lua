-- mason-lspconfig.lua

local M = {
  'williamboman/mason-lspconfig.nvim', -- mason extensions for LSPs
  dependencies = { 'williamboman/mason.nvim' },
  lazy = true,
}

function M.config()
  local servers = require('sykesm.lsp.servers')
  local mason_lspconfig = require('mason-lspconfig')

  mason_lspconfig.setup({
    automatic_installation = false,
    ensure_installed = vim.tbl_keys(servers),
  })
end

return M
