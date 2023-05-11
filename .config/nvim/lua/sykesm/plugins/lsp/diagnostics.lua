-- diagnostics.lua

-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#change-diagnostic-symbols-in-the-sign-column-gutter
local signs = {
  Error = '󰅚 ', -- close_circle_outline
  Warn = '󰀪 ', -- alert_outline
  Hint = '󰌶 ', -- lightbulb_outline
  Info = ' ', -- nf-oct-info
}
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.g.lsp_diagnostics_active = true
function _G.lsp_toggle_diagnostics()
  if vim.g.lsp_diagnostics_active then
    vim.g.lsp_diagnostics_active = false
    vim.diagnostic.disable()
  else
    vim.g.lsp_diagnostics_active = true
    vim.diagnostic.enable()
  end
end

vim.api.nvim_set_keymap(
  'n',
  '<leader>tt',
  ':call v:lua.lsp_toggle_diagnostics()<CR>',
  { noremap = true, silent = true }
)
