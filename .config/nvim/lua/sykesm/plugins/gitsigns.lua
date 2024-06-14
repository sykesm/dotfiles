-- gitsigns.lua

return {
  'lewis6991/gitsigns.nvim',
  event = 'BufReadPost',
  cmd = 'Gitsigns',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  },
}
