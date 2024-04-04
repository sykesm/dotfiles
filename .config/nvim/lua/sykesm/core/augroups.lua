-- augroups.lua

-- Time out on key codes but not mappings.
-- Basically this makes terminal Vim work sanely under tmux.
local fast_escape = vim.api.nvim_create_augroup('FastEscape', { clear = true })
vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
  group = fast_escape,
  pattern = '*',
  command = 'set timeoutlen=0',
})
vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
  group = fast_escape,
  pattern = '*',
  command = 'set timeoutlen=1000',
})

-- save on focus loss in tmux or gui
local save_focus_lost = vim.api.nvim_create_augroup('SaveFocusLost', { clear = true })
vim.api.nvim_create_autocmd({ 'FocusLost' }, {
  group = save_focus_lost,
  pattern = '*',
  command = 'silent! wa',
})

-- briefly flash what's been yanked
local highlight_yank = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
  group = highlight_yank,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ timeout = 100 })
  end,
})

-- return to the last edit position when opening files
local restore_position = vim.api.nvim_create_augroup('RestorePosition', { clear = true })
vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
  group = restore_position,
  pattern = '*',
  callback = function(ev)
    if string.find(vim.fn.bufname(ev.buf), 'neo-tree ') == 1 then
      return
    end
    -- '" is the last position marker
    if vim.fn.line('\'"') > 0 and vim.fn.line('\'"') <= vim.fn.line('$') then
      vim.fn.execute('normal! g`"')
    end
  end,
})
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  group = restore_position,
  pattern = 'COMMIT_EDITMSG',
  callback = function(_)
    vim.fn.setpos('.', { 0, 1, 1, 0 })
  end,
})

-- pom.xml
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = 'pom.xml',
  command = 'setlocal noexpandtab shiftwidth=4 tabstop=4',
})
-- autocmd BufNewFile,BufRead pom.xml,**/pom.xml setl noexpandtab shiftwidth=4 tabstop=4
