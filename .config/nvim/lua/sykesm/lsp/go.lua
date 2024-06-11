-- go.lua

local M = {}

---------------------------------------------------------------------
-- https://github.com/neovim/neovim/issues/14618#issuecomment-846549867
---------------------------------------------------------------------
local function get_lsp_client()
  -- Get lsp client for current buffer
  local clients = vim.lsp.get_clients()
  if next(clients) == nil then
    return nil
  end

  local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
  for _, client in pairs(clients) do
    local filetypes = client.config.filetypes ---@diagnostic disable-line missing-fields
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      return client
    end
  end

  return nil
end

---------------------------------------------------------------------
-- Try to invoke the source.organizeImports action on save.
--
-- This was cobbled together with some help from these links and
-- probably isn't the best implementation.
--
-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#imports
-- https://github.com/neovim/nvim-lspconfig/issues/115#issuecomment-849865673
--
-- The following looked like a promising method because it uses the
-- builtin client to invoke the code action but it kept doing weird changes
-- to the buffer.
--
-- vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
--
-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#imports
---------------------------------------------------------------------
function M.organize_imports(timeout_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { 'source.organizeImports' } }

  local client = get_lsp_client()
  if not client then
    return
  end

  local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, timeout_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end

return M
