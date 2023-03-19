-- load mason and setup LSP servers

local mason_ok, mason = pcall(require, 'mason')
if not mason_ok then
  return
end

local mason_lspconfig_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not mason_lspconfig_ok then
  return
end

local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_ok then
  return
end

local servers = require('sykesm.plugins.lsp.servers')
local on_attach = require('sykesm.plugins.lsp.on-attach')

mason.setup()
mason_lspconfig.setup({
  automatic_installation = false,
  ensure_installed = vim.tbl_keys(servers),
})
mason_lspconfig.setup_handlers({
  function(server_name)
    local config = {
      capabilities = require('sykesm.plugins.lsp.capabilities').create(),
      on_attach = on_attach,
    }
    local server_opts = servers[server_name]
    if type(server_opts) == 'table' then
      config = vim.tbl_deep_extend('keep', server_opts, config)
      lspconfig[server_name].setup(config)
    elseif type(server_opts) == 'function' then
      server_opts(config)
    end
  end,
})
