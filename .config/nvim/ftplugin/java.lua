local jdtls_ok, jdtls = pcall(require, 'jdtls')
if not jdtls_ok then
  return
end

local config = require('sykesm.plugins.lsp.jdtls').config()
jdtls.start_or_attach(config)
