-- mason.lua

local M = {
  'williamboman/mason.nvim', -- installer for LSPs (and more)
  cmd = 'Mason',
}

function M.config()
  require('mason').setup()
end

return M
