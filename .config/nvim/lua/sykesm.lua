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

local hascmp, _ = pcall(require, 'cmp')
if hascmp then
  require('site/cmp')
end

local haslspsig, _ = pcall(require, 'lsp-signature')
if haslspsig then
  require('lsp_signature').setup({
    hint_prefix = "¦ ",
  })
end

local has_nvim_go, _ = pcall(require, 'go')
if has_nvim_go then
  require('go').setup()
end
