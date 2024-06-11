-- diagnostics.lua

local M = {}

-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#change-diagnostic-symbols-in-the-sign-column-gutter
local signs = {
  Error = '󰅚 ', -- close_circle_outline
  Warn = '󰀪 ', -- alert_outline
  Hint = '󰌶 ', -- lightbulb_outline
  Info = ' ', -- nf-oct-info
}

local setup_done = false

function M.setup()
  if setup_done then
    return
  end
  setup_done = true

  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  function _G.lsp_toggle_diagnostics()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  end

  vim.api.nvim_set_keymap(
    'n',
    '<leader>tt',
    ':call v:lua.lsp_toggle_diagnostics()<CR>',
    { noremap = true, silent = true }
  )
end

return M
