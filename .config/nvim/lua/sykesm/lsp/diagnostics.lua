-- diagnostics.lua

local M = {}

local setup_done = false

function M.setup()
  if setup_done then
    return
  end
  setup_done = true

  vim.diagnostic.config({
    float = {
      header = '',
      border = 'rounded',
      source = true,
    },
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '',
        [vim.diagnostic.severity.WARN] = '',
        [vim.diagnostic.severity.INFO] = '',
        [vim.diagnostic.severity.HINT] = '',
      },
    },
  })

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
