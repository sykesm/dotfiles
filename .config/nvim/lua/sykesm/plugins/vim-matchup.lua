-- vim-matchup.lua

return {
  'andymass/vim-matchup', -- extended matching
  event = 'BufReadPost',
  config = function()
    vim.g.matchup_matchparen_enabled = 1 --  override with :DoMatchParen,:NoMatchParen
    vim.g.matchup_matchparen_offscreen = { method = 'status' }
  end,
}
