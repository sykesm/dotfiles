-- neodev.lua

local neodev_ok, neodev = pcall(require, 'neodev')
if not neodev_ok then
  return
end

neodev.setup()
