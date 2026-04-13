-- which-key.lua

return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    delay = function(ctx)
      return ctx.plugin and 0 or 1000
    end,
    preset = 'modern',
  },
  keys = {
    {
      '<leader>wk',
      function()
        require('which-key').show()
      end,
      desc = 'Buffer local keymaps (which-key)',
    },
  },
}
