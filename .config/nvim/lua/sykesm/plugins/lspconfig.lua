-- lspconfig.lua

local M = {
  'neovim/nvim-lspconfig', -- common config for builtin LSP client
  dependencies = {
    'mason-org/mason.nvim', -- installer for LSPs (and more)
    'mason-org/mason-lspconfig.nvim', -- mason extensions for LSPs
    'j-hui/fidget.nvim', -- Useful status updates for LSP
  },
  event = { 'BufReadPre', 'BufNewFile' },
}

function M.config()
  require('sykesm.lsp.diagnostics').setup()
  require('sykesm.lsp.regal').setup()

  vim.api.nvim_set_hl(0, 'LspReferenceText', { default = true, link = 'Visual' })
  vim.api.nvim_set_hl(0, 'LspReferenceRead', { default = true, link = 'Visual' })
  vim.api.nvim_set_hl(0, 'LspReferenceWrite', { default = true, link = 'Visual' })

  ---@diagnostic disable:duplicate-set-field,inject-field
  local open_floating_preview = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or 'single' -- single, double, rounded, solid, shadow
    return open_floating_preview(contents, syntax, opts, ...)
  end

  vim.lsp.config('*', {
    capabilities = require('sykesm.lsp.capabilities').create(),
    on_attach = require('sykesm.lsp.on-attach'),
  })

  local servers = require('sykesm.lsp.servers')
  for server_name, server_options in pairs(servers) do
    if type(server_options) == 'table' then
      vim.lsp.config(server_name, server_options)
    elseif type(server_options) == 'boolean' then
      vim.lsp.enable(server_name, server_options)
    elseif type(server_options) == 'function' then
      local options = vim.lsp.config['*'] or {}
      options = server_options(options) or options
      vim.lsp.config(server_name, options)
    end
  end
end

return M
