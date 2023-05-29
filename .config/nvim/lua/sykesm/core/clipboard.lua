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

local osc52_ok, osc52 = pcall(require, 'osc52')
if osc52_ok then
  osc52.setup({ silent = true })
end

-- Copy over SSH uses OSC 52 but paste is from the local register.
if vim.fn.empty(vim.env.SSH_CLIENT) == 0 and osc52_ok then
  local function copy(lines, _)
    osc52.copy(table.concat(lines, '\n'))
  end

  local function paste()
    return {
      vim.fn.split(vim.fn.getreg(''), '\n'),
      vim.fn.getregtype(''),
    }
  end

  vim.g.clipboard = {
    name = 'osc52-clipboard',
    copy = {
      ['+'] = copy,
      ['*'] = copy,
    },
    paste = {
      ['+'] = paste,
      ['*'] = paste,
    },
  }
  return
end
