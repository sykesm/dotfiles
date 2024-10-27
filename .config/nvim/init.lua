vim.opt.shortmess:append({ I = true }) -- avoid flashing intro screen bugs

require('sykesm.core.options')
require('sykesm.lazy')
require('sykesm.core.augroups')
require('sykesm.core.clipboard')
require('sykesm.core.highlight')
require('sykesm.core.keymaps')

if vim.env.NVIM_LSP_DEBUG then
  vim.lsp.set_log_level('debug')
  vim.print(require('sykesm.lsp.capabilities').create())
  if vim.fn.has('nvim-0.5.1') == 1 then
    require('vim.lsp.log').set_format_func(vim.inspect)
  end
end
