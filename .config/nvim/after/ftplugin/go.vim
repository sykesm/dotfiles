setlocal noexpandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal spelloptions=camel
setlocal tabstop=2
setlocal textwidth=80

if has("nvim")
  augroup NvimGoLsp
    autocmd!
    autocmd BufWritePre *.go lua organize_imports(1000)
  augroup END
endif
