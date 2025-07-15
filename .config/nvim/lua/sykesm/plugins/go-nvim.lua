-- go-nvim.lua

return {
  'ray-x/go.nvim',
  -- The last commit before errors were highlighted like comments.
  commit = 'a3455f48cff718a86275115523dcc735535a13aa',
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
