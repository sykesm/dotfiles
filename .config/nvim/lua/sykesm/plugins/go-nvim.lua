-- go-nvim.lua

local go_ok, go = pcall(require, 'go')
if not go_ok then
  return
end

go.setup({
  -- until codelenses are fixed in neovim and the plugin
  lsp_codelens = false,
})
