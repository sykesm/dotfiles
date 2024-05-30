-- colorscheme.lua
-- nightfly is a 24-bit color scheme with LSP support

local custom_highlight = vim.api.nvim_create_augroup('CustomHighlight', {})
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = 'nightfly',
  callback = function()
    -- Use CelloBlue instead of SlateBlue
    vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'NightflyCelloBlue' })
  end,
  group = custom_highlight,
})

-- nightfly color scheme options
vim.g.nightflyTransparent = 1
vim.g.nightflyUndercurls = 1

local status, _ = pcall(function()
  vim.cmd('colorscheme nightfly')
end)
if not status then
  print('Colorscheme not found!') -- print error if colorscheme not installed
  return
end
