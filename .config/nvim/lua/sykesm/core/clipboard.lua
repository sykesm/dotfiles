-- clipboard.lua

-- Use tmux buffers for clipboard integration when running in tmux.
-- If the tmux version is new enough, send copied text to the terminal client
-- with OSC 52.
if vim.fn.empty(vim.env.TMUX) == 0 and vim.fn.executable('tmux') == 1 then
  local load_command = { 'tmux', 'load-buffer', '-' }
  if string.find(vim.fn.system('tmux -V'), '3%.[2-9]') ~= nil then
    load_command = { 'tmux', 'load-buffer', '-w', '-' }
  end
  vim.g.clipboard = {
    name = 'tmux-clipboard',
    copy = {
      ['+'] = load_command,
      ['*'] = load_command,
    },
    paste = {
      ['+'] = { 'tmux', 'save-buffer', '-' },
      ['*'] = { 'tmux', 'save-buffer', '-' },
    },
    cache_enabled = true,
  }
  return
end

-- Copy over SSH uses OSC 52 but paste is from the local register.
if vim.fn.empty(vim.env.SSH_TTY) == 0 then
  -- check for support?
  -- https://github.com/neovim/neovim/pull/26064/files#diff-776616fe246164a7a47bb8dcca8edfcdc1d00c3a3525badb93547dde5341ffbc
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
  return
end
