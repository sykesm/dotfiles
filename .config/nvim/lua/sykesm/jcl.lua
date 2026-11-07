-- jcl.lua: folds and motions for browsing z/OS JCL
local M = {}

-- In-stream data can hold JCL (jobs sent to the internal reader), so
-- statements are only recognised outside the syntax file's data regions.
local function in_data(lnum)
  for _, id in ipairs(vim.fn.synstack(lnum, 1)) do
    local name = vim.fn.synIDattr(id, 'name')
    if name:match('^jclData') or name:match('^jclDlm') then
      return true
    end
  end
  return false
end

local function operation(line)
  if line:sub(1, 3) == '//*' then
    return nil
  end
  local op = line:match('^//[%u$#@][%u%d$#@.]* +(%u+)%f[%W]') or line:match('^// +(%u+)%f[%W]')
  if op == 'JOB' or op == 'PROC' or op == 'PEND' or op == 'EXEC' then
    return op
  end
end

-- Per buffer: statement operation and fold level of each line, by changedtick.
local cache = {}

local function scan(bufnr)
  local tick = vim.api.nvim_buf_get_changedtick(bufnr)
  local c = cache[bufnr]
  if c and c.tick == tick then
    return c
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local ops, levels = {}, {}
  local job, proc = false, nil -- proc: fold level of the open procedure
  for lnum, line in ipairs(lines) do
    local op = operation(line)
    if op and in_data(lnum) then
      op = nil
    end
    ops[lnum] = op
    if op == 'JOB' then
      job, proc = true, nil
      levels[lnum] = '>1'
    elseif op == 'PROC' then
      proc = job and 2 or 1
      levels[lnum] = '>' .. proc
    elseif op == 'PEND' and proc then
      levels[lnum] = '<' .. proc
      proc = nil
    elseif op == 'EXEC' then
      levels[lnum] = '>' .. ((proc or (job and 1 or 0)) + 1)
    else
      levels[lnum] = '='
    end
  end

  -- Comment statements just before a fold start stay visible above it.
  for lnum = 2, #lines do
    local start = levels[lnum]:match('^>(%d+)$')
    if start then
      local l = lnum - 1
      while l >= 1 and lines[l]:sub(1, 3) == '//*' and levels[l] == '=' do
        levels[l] = tostring(tonumber(start) - 1)
        l = l - 1
      end
    end
  end

  c = { tick = tick, ops = ops, levels = levels }
  cache[bufnr] = c
  return c
end

function M.foldexpr()
  return scan(vim.api.nvim_get_current_buf()).levels[vim.v.lnum] or '='
end

-- Move to the count'th next (dir 1) or previous (dir -1) statement in ops.
local function jump(dir, wanted)
  local bufnr = vim.api.nvim_get_current_buf()
  local ops = scan(bufnr).ops
  local lnum, last = vim.fn.line('.'), vim.api.nvim_buf_line_count(bufnr)
  local target
  for _ = 1, vim.v.count1 do
    local l = lnum + dir
    while l >= 1 and l <= last and not wanted[ops[l]] do
      l = l + dir
    end
    if l < 1 or l > last then
      break
    end
    target, lnum = l, l
  end
  if target then
    vim.cmd("normal! m'")
    vim.api.nvim_win_set_cursor(0, { target, 0 })
  end
end

function M.keymaps(bufnr)
  local steps, units = { EXEC = true }, { JOB = true, PROC = true }
  local function map(lhs, fn, desc)
    vim.keymap.set({ 'n', 'x', 'o' }, lhs, fn, { buffer = bufnr, desc = desc })
  end
  map(']]', function() jump(1, steps) end, 'Next JCL step')
  map('[[', function() jump(-1, steps) end, 'Previous JCL step')
  map('][', function() jump(1, units) end, 'Next JCL job or procedure')
  map('[]', function() jump(-1, units) end, 'Previous JCL job or procedure')
end

return M
