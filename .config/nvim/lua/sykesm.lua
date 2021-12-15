local haslspconfig, _ = pcall(require, 'lspconfig')
local haslspinstall, _ = pcall(require, 'nvim-lsp-installer')
if haslspconfig and haslspinstall then
  require('site/lsp')
end

local hastsconfig, _ = pcall(require, 'nvim-treesitter.configs')
if hastsconfig then
  require('site/treesitter')
end

local hastscope, _ = pcall(require, 'telescope')
if hastscope then
  require('site/telescope')
end

local hastodo, _ = pcall(require, 'todo-comments')
if hastodo then
  require('site/todo')
end

local hascompe, _ = pcall(require, 'compe')
if hascompe then
  require('site/compe')
end

require('lsp_signature').setup({
  hint_prefix = "¦ ",
})
