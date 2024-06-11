setlocal noexpandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal spell
setlocal tabstop=2
setlocal textwidth=80

augroup NvimGoLsp
  autocmd!
  autocmd BufWritePre *.go lua require('sykesm.lsp.go').organize_imports(1000)
augroup END
