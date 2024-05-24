-- clipboard.lua

---@diagnostic disable-next-line unused
local function term_supports_osc52()
  if string.find(vim.env.TERM_PROGRAM or '', 'alacritty') then
    return true
  end

  local supported = false
  require('vim.termcap').query('Ms', function(cap, found, seq)
    if not found then
      return
    else
      assert(cap == 'Ms')
    end

    -- If the terminal reports a sequence other than OSC 52 for the Ms capability
    -- then ignore it. We only support OSC 52 (for now)
    if not seq:match('^\027%]52') then
      return
    end

    supported = true
  end)

  return supported
end

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

-- Copy over SSH uses OSC 52
if vim.fn.empty(vim.env.SSH_TTY) == 0 then
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
    cache_enabled = true,
  }
  return
end
