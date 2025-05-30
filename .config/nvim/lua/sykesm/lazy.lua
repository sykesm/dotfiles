-- lazy.lua

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({ import = 'sykesm.plugins' }, {
  install = {
    colorscheme = { 'nightfly' },
  },
  change_detection = {
    notify = false,
  },
  rocks = {
    enabled = false,
  },
})
