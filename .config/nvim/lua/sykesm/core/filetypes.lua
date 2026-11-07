-- filetypes.lua

-- A job or catalogued procedure: comment statements, then //name JOB or PROC.
local function jcl_content(_, bufnr)
  for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, 10, false)) do
    if not line:match('^//%*') then
      local op = line:match('^//[%u$#@][%u%d$#@]* +(%u+)%f[%W]')
      return (op == 'JOB' or op == 'PROC') and 'jcl' or nil
    end
  end
end

vim.filetype.add({
  extension = {
    CBL = 'cobol',
    CPY = 'cobol',
    jcl = 'jcl',
    JCL = 'jcl',
  },
  pattern = {
    ['.*/COBOL/[^.]+'] = 'cobol',
    ['.*/JCL/[^.]+'] = 'jcl',
    ['.*/PROC/[^.]+'] = 'jcl',
    ['.*/ASSEMBLER/[^.]+'] = 'asm',
    ['.*/Assembler/[^.]+'] = 'asm',
    ['.*'] = { jcl_content, { priority = -math.huge } },
  },
})
