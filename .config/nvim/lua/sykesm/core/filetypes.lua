-- filetypes.lua

vim.filetype.add({
  extension = {
    CBL = 'cobol',
    CPY = 'cobol',
  },
  pattern = {
    ['.*/COBOL/[^.]+'] = 'cobol',
    ['.*/JCL/[^.]+'] = 'jcl',
    ['.*/PROC/[^.]+'] = 'jcl',
    ['.*/ASSEMBLER/[^.]+'] = 'asm',
    ['.*/Assembler/[^.]+'] = 'asm',
  },
})
