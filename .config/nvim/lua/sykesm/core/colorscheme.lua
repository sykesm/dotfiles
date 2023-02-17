-- colorscheme.lua

-- nightfly is a 24-bit color scheme with LSP support
local status, _ = pcall(function() vim.cmd('colorscheme nightfly') end)
if not status then
  print("Colorscheme not found!") -- print error if colorscheme not installed
  return
end
