-- typescript-tools.lua

local M = {
  'pmizio/typescript-tools.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'neovim/nvim-lspconfig',
  },
  ft = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
}

function M.opts()
  return {
    on_attach = require('sykesm.lsp.on-attach'),
    capabilities = require('sykesm.lsp.capabilities').create(),
    settings = {
      jsx_close_tag = {
        enable = true,
        filetypes = { 'javascriptreact', 'typescriptreact' },
      },
      tsserver_file_preferences = {},
      tsserver_format_options = {
        insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
      },
    },
  }
end

return M
