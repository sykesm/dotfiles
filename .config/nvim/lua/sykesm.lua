local haslspconfig, _ = pcall(require, 'lspconfig')
local haslspinstall, _ = pcall(require, 'lspinstall')
if haslspinstall and haslspconfig then
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
