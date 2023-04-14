-- colorscheme.lua

-- nightfly color scheme options
vim.g.nightflyTransparent = 1
vim.g.nightflyUndercurls = 1

-- nightfly is a 24-bit color scheme with LSP support
local status, _ = pcall(function()
  vim.cmd('colorscheme nightfly')
end)
if not status then
  print('Colorscheme not found!') -- print error if colorscheme not installed
  return
end

-- -- If/when overrides are necessary..
-- local custom_highlight = vim.api.nvim_create_augroup("CustomHighlight", {})
-- vim.api.nvim_create_autocmd("ColorScheme", {
--   pattern = "nightfly",
--   callback = function()
--     vim.api.nvim_set_hl(0, "Function", { fg = "#82aaff", bold = true })
--   end,
--   group = custom_highlight,
-- })
