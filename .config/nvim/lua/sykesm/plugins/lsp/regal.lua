-- The regal language server is very much a work in progress
-- and mason doesn't support it yet.

local function regal_on_attach(client, bufnr)
  -- regal doesn't implement pull diagnostics but claims it does
  -- this causes errors starting with nvim 0.10 due to
  -- https://github.com/neovim/neovim/issues/22838
  client.server_capabilities.diagnosticProvider = nil
  require('sykesm.plugins.lsp.on-attach')(client, bufnr)
end

local function regal_path()
  -- Look for a custom build before falling back to a
  -- version that's on the path.
  local custom_paths = {
    vim.fn.expand('~/projects/regal/regal'),
    'regal',
  }

  for _, cp in ipairs(custom_paths) do
    if vim.fn.executable(cp) then
      return cp
    end
  end

  return nil
end

local function setup_regal()
  -- Only configure regal if it's available.
  local path = regal_path()
  if not path then
    return
  end

  require('lspconfig').regal.setup({
    cmd = { path, 'language-server' },
    capabilities = require('sykesm.plugins.lsp.capabilities').create(),
    on_attach = regal_on_attach,
  })
end

setup_regal()
