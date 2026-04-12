vim.opt.shortmess:append({ I = true }) -- avoid flashing intro screen bugs

require('sykesm.core.options')
require('sykesm.lazy')
require('sykesm.core.augroups')
require('sykesm.core.clipboard')
require('sykesm.core.highlight')
require('sykesm.core.keymaps')

if vim.fn.has('nvim-0.12.1') == 1 then
  require('vim._core.ui2').enable({})
end

if vim.env.NVIM_LSP_DEBUG then
  local llog = require('vim.lsp.log')
  vim.print(require('sykesm.lsp.capabilities').create())
  llog.set_level('debug')
  llog.set_format_func(vim.inspect)
end
