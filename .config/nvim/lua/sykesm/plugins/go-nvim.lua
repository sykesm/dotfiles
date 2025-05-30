-- go-nvim.lua

return {
  'ray-x/go.nvim',
  dependencies = {
    'ray-x/guihua.lua', -- float term, go.nvim gui support
  },
  opts = {
    diagnostic = false,
    lsp_codelens = true,
  },
  ft = {
    'go',
    'gomod',
    'gosum',
    'gotmpl',
    'gohtmltmpl',
    'gotexttmpl',
  },
}
