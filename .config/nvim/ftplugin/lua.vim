setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2

if has("nvim")
  augroup NvimLuaLsp
    autocmd!
    autocmd BufWritePre *.lua lua vim.lsp.buf.formatting_seq_sync()
  augroup END
endif
