-- nightfly.lua
-- nightfly is a 24-bit color scheme with treesitter support

local M = { 'bluz71/vim-nightfly-guicolors', lazy = false, priority = 1000 }

function M.config()
  -- nightfly color scheme options
  vim.g.nightflyTransparent = 1
  vim.g.nightflyUndercurls = 1

  local custom_highlight = vim.api.nvim_create_augroup('CustomHighlight', {})
  vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = 'nightfly',
    callback = function()
      -- Use CelloBlue instead of SlateBlue
      vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'NightflyCelloBlue' })
    end,
    group = custom_highlight,
  })

  vim.cmd('colorscheme nightfly')
end

return M
