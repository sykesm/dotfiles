local haslspconfig, _ = pcall(require, 'lspconfig')
local has_mason, _ = pcall(require, 'mason')
local has_mason_lspconfig, _ = pcall(require, 'mason-lspconfig')
if haslspconfig and has_mason and has_mason_lspconfig then
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

local haslspsig, _ = pcall(require, 'lsp_signature')
if haslspsig then
  require('lsp_signature').setup({
    hint_prefix = "¦ ",
  })
end

local has_nvim_go, _ = pcall(require, 'go')
if has_nvim_go then
  require('go').setup()
end
