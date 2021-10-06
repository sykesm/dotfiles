setlocal commentstring=#\ %s
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2

if has("nvim")
  augroup NvimElixirLsp
    autocmd!
    autocmd BufWritePre *.ex lua vim.lsp.buf.formatting_seq_sync(nil, 1000)
    autocmd BufWritePre *.exs lua vim.lsp.buf.formatting_seq_sync(nil, 1000)
  augroup END
endif
