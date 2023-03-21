-- init.lua - LSP module

vim.api.nvim_set_hl(0, 'LspReferenceText', { default = true, link = 'Visual' })
vim.api.nvim_set_hl(0, 'LspReferenceRead', { default = true, link = 'Visual' })
vim.api.nvim_set_hl(0, 'LspReferenceWrite', { default = true, link = 'Visual' })

require('sykesm.plugins.lsp.neodev')
require('sykesm.plugins.lsp.mason')

require('sykesm.plugins.lsp.diagnostics')
require('sykesm.plugins.lsp.fidget')
require('sykesm.plugins.lsp.imports')
require('sykesm.plugins.lsp.null-ls')
