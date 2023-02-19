-- plugins-setup.lua

-- Install packer if it's not already installed
local is_bootstrap = (function()
  local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if vim.fn.empty(vim.fn.glob(install_path)) == 0 then
    return false
  end
  vim.fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
  vim.cmd([[packadd packer.nvim]])
  return true
end)()

local ok, packer = pcall(require, 'packer')
if not ok then
  return
end

packer.startup(function(use)
  use('wbthomason/packer.nvim')

  use({
    'neovim/nvim-lspconfig', -- common config for builtin LSP client
    requires = {
      'williamboman/mason.nvim', -- installer for LSPs (and more)
      'williamboman/mason-lspconfig.nvim', -- mason extensions for LSPs
      'j-hui/fidget.nvim', -- Useful status updates for LSP
      'folke/neodev.nvim', -- LSP config for nvim lua
    },
  })

  use({ 'L3MON4D3/LuaSnip', tag = 'v1.*' }) -- snippets engine
  use({
    'hrsh7th/nvim-cmp', -- auto completion plugin for neovim
    requires = {
      'hrsh7th/cmp-buffer', -- comletion from buffers
      'hrsh7th/cmp-nvim-lsp', -- LSP completion
      'hrsh7th/cmp-path', -- completion from paths
      'saadparwaiz1/cmp_luasnip', -- completion from snippets
    },
  })
  use('rafamadriz/friendly-snippets')
  use('ray-x/lsp_signature.nvim') -- provide function signature help

  -- Fuzzy Finder (files, lsp, etc)
  use({ 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } })

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available
  use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable('make') == 1 })

  use({
    'nvim-treesitter/nvim-treesitter', -- AST based syntax highlighting and navigation
    run = function()
      pcall(require('nvim-treesitter.install').update({ with_sync = true }))
    end,
  })
  use({ 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' })
  use({ 'nvim-treesitter/playground', after = 'nvim-treesitter' }) -- view treesitter info
  use({ 'p00f/nvim-ts-rainbow', after = 'nvim-treesitter' }) -- rainbow parens

  use('bluz71/vim-nightfly-guicolors') -- color scheme that supports treesitter
  use('nvim-lualine/lualine.nvim') -- statusline

  use('tpope/vim-commentary') -- extended commenting of blocks and objects
  use('tpope/vim-fugitive') -- git integration
  use('tpope/vim-repeat') -- extend '.' to plugin map
  use('tpope/vim-surround') -- change surrounding quotes and tags
  use('lewis6991/gitsigns.nvim') -- line markers for git changes
  -- use('numToStr/Comment.nvim') -- "gc" to comment visual regions/lines

  use('andymass/vim-matchup') -- extended matching
  use({ 'fatih/vim-nginx', ft = 'nginx' }) -- nginx config
  use('hashivim/vim-hashicorp-tools') -- terraform and friends
  use('majutsushi/tagbar') -- code tree
  use({ 'plasticboy/vim-markdown', ft = 'markdown' }) -- extended markdown

  -- playing around with dap/debug
  use('mfussenegger/nvim-dap')
  use('rcarriga/nvim-dap-ui')
  use('theHamsta/nvim-dap-virtual-text')

  -- ray-x/go.nvim commit 470349c does something weird with defer_fn that clears the
  -- screen during startup. It got reverted in cfa1089 and then restored in 1b3d21a.
  use({
    'ray-x/go.nvim', -- go language stuff w/o vim-go
    requires = { 'ray-x/guihua.lua' }, -- float term, go.nvim gui support
    commit = 'cfa1089',
  })

  use({ 'rust-lang/rust.vim', ft = 'rust' }) -- rust stuff
  use({ 'jose-elias-alvarez/typescript.nvim' }) -- typescript
  use({ 'jose-elias-alvarez/null-ls.nvim' }) -- typescript formatters & linters
  use({ 'jay-babu/mason-null-ls.nvim' }) -- bridges gap b/w mason & null-ls

  use({
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
      'MunifTanjim/nui.nvim',
    },
  })

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When bootstrapping a configuration, it doesn't make sense to execute all of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print('==================================')
  print('    Plugins are being installed')
  print('    Wait until Packer completes,')
  print('       then restart nvim')
  print('==================================')
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  -- command = 'source <afile> | silent! LspStop | silent! LspStart | PackerSync',
  command = 'source <afile> | PackerSync',
  group = packer_group,
  pattern = { 'plugins-setup.lua' },
})
