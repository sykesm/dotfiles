-- go.lua

local M = {}

--- Get the Go Language Server client attached to the current buffer.
---@return vim.lsp.Client?
local function get_go_lsp_client()
  -- Get lsp client for current buffer
  local clients = vim.lsp.get_clients({ name = 'gopls' })
  if #clients > 0 then
    return clients[1]
  end
  return nil
end

-----------------------------------------------------------------------
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
-- vim.lsp.buf.code_action({
--   context = { only = { 'source.organizeImports' } },
--   apply = true,
-- })
--
-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#imports
-----------------------------------------------------------------------
function M.organize_imports(timeout_ms)
  local client = get_go_lsp_client()
  if not client then
    return
  end

  local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
  params.context = { only = { 'source.organizeImports' } } ---@diagnostic disable-line: inject-field

  local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, timeout_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
      end
    end
  end
end

return M
