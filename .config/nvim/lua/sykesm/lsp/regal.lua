-- The regal language server is very much a work in progress
-- and mason doesn't support it yet.

local M = {}

function M.regal_path()
  -- Look for a custom build before falling back to a version that's
  -- on the path.
  local custom_paths = {
    vim.fn.expand('~/projects/regal/regal'),
    'regal',
  }

  for _, cp in ipairs(custom_paths) do
    if vim.fn.executable(cp) ~= 0 then
      return cp
    end
  end

  return nil
end

function M.setup()
  local path = M.regal_path() -- Only configure regal if it's available.
  if not path then
    return
  end

  local util = require('lspconfig.util')
  local root_pattern = util.root_pattern('.regal', '.oparoot', '.manifest', '*.rego')

  require('lspconfig').regal.setup({
    cmd = { path, 'language-server' },
    capabilities = require('sykesm.lsp.capabilities').create(),
    on_attach = require('sykesm.lsp.on-attach'),
    root_dir = function(fname)
      return root_pattern(fname) or util.find_git_ancestor(fname)
    end,
  })
end

return M
