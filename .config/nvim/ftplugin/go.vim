setlocal noexpandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2

if has("nvim")
  " Format prior to save using LSP
  autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)
endif
