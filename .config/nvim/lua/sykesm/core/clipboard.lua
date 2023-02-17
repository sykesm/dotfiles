-- clipboard.lua

-- Use tmux buffers instead GUI for clipboard integration when running in tmux.
-- If the tmux version is new enough, send copied text to the terminal client
-- with OSC 52.
if vim.fn.empty(vim.env.TMUX) == 0 and vim.fn.executable('tmux') == 1 then
  local load_command = { 'tmux', 'load-buffer', '-' }
  if string.find(vim.fn.system('tmux -V'), '3%.[2-9]') ~= nil then
    load_command = { 'tmux', 'load-buffer', '-w', '-' }
  end
  vim.g.clipboard = {
    name = 'myClipboard',
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
end
