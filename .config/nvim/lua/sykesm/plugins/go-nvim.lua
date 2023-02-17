-- go-nvim.lua

local go_ok, go = pcall(require, 'go')
if not go_ok then
  return
end

go.setup()
