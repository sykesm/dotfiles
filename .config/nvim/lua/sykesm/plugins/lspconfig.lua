-- lspconfig.lua

local M = {
  'neovim/nvim-lspconfig', -- common config for builtin LSP client
  dependencies = {
    'williamboman/mason.nvim', -- installer for LSPs (and more)
    'williamboman/mason-lspconfig.nvim', -- mason extensions for LSPs
    'j-hui/fidget.nvim', -- Useful status updates for LSP
    { 'folke/neodev.nvim', opts = {} }, -- LSP config for nvim lua
  },
  event = { 'BufReadPre', 'BufNewFile' },
}

function M.config()
  local lspconfig = require('lspconfig')
  local mason_lspconfig = require('mason-lspconfig')
  local servers = require('sykesm.lsp.servers')

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

  mason_lspconfig.setup_handlers({
    function(server_name)
      local config = {
        capabilities = require('sykesm.lsp.capabilities').create(),
        on_attach = require('sykesm.lsp.on-attach'),
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
end

return M
