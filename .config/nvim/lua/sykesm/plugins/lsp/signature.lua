-- signature.lua

local lsp_signature_ok, lsp_signature = pcall(require, 'lsp_signature')
if not lsp_signature_ok then
  return
end

lsp_signature.setup({
  hint_prefix = "¦ ",
})
