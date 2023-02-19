-- diagnostics.lua

-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#change-diagnostic-symbols-in-the-sign-column-gutter
local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- https://np.reddit.com/r/backtickbot/comments/ng3qz4/httpsnpredditcomrneovimcommentsng0dj0lsp/
vim.g.lsp_diagnostics_active = true
function _G.lsp_toggle_diagnostics()
  if vim.g.lsp_diagnostics_active then
    vim.g.lsp_diagnostics_active = false
    vim.diagnostic.hide()
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.lsp.handlers['textDocument/publishDiagnostics'] = function() end
  else
    vim.g.lsp_diagnostics_active = true
    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
    })
    vim.diagnostic.show()
  end
end

vim.api.nvim_set_keymap(
  'n',
  '<leader>tt',
  ':call v:lua.lsp_toggle_diagnostics()<CR>',
  { noremap = true, silent = true }
)
