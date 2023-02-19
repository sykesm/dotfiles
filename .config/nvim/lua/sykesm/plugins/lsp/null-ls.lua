-- null-ls.lua

local null_ls_ok, null_ls = pcall(require, 'null-ls')
if not null_ls_ok then
  return
end

null_ls.setup({
  -- on_attach = null_ls_on_attach,
  sources = {
    null_ls.builtins.formatting.stylua,
  },
})

local mason_null_ls_ok, mason_null_ls = pcall(require, 'mason-null-ls')
if not mason_null_ls_ok then
  return
end

mason_null_ls.setup({
  ensure_installed = {
    'stylua', -- lua formatter
  },
  automatic_installation = false,
})
