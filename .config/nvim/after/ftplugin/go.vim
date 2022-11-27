setlocal noexpandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2
setlocal textwidth=80

if has("nvim")
  augroup NvimGoLsp
    autocmd!
    " Format prior to save using LSP
    autocmd BufWritePre *.go lua organize_imports(1000)
    autocmd BufWritePre *.go lua vim.lsp.buf.format({ timeout_ms = 1000 })
  augroup END
endif
