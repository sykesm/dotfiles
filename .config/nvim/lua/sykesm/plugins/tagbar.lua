-- tagbar.lua

return {
  'majutsushi/tagbar', -- code tree
  cmd = {
    'TagbarOpen',
    'TagbarClose',
    'TagbarToggle',
  },
  keys = {
    { '<F8>', '<cmd>TagbarToggle<cr>', desc = 'Toggle TagBar' },
  },
}
