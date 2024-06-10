-- mason-lspconfig.lua

local M = {
  'williamboman/mason-lspconfig.nvim', -- mason extensions for LSPs
  dependencies = { 'williamboman/mason.nvim' },
  event = { 'BufReadPre', 'BufNewFile' },
}

local function ensure_mason_installed(servers)
  local ensure_installed = {}
  for k, v in pairs(servers) do
    if type(v) ~= 'table' or v.ensure_installed ~= false then
      table.insert(ensure_installed, k)
    end
  end
  return ensure_installed
end

function M.config()
  local servers = require('sykesm.lsp.servers')
  local mason_lspconfig = require('mason-lspconfig')

  mason_lspconfig.setup({
    automatic_installation = false,
    ensure_installed = ensure_mason_installed(servers),
  })
end

return M
