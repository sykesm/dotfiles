-- mason.lua

local M = {
  'mason-org/mason.nvim', -- installer for LSPs (and more)
  cmd = 'Mason',
}

function M.config()
  require('mason').setup()
end

return M
