-- vim-airline.lua
if vim.env.POWERLINE ~= nil and vim.env.POWERLINE ~= '' then
  vim.g.airline_powerline_fonts = 1
end
vim.g['airline#extensions#tabline#enabled'] = 1
vim.g['airline#extensions#tagbar#enabled'] = 0
