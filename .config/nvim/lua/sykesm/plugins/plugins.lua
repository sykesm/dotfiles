return {

  { 'tpope/vim-fugitive' }, -- git integration
  { 'tpope/vim-repeat' }, -- extend '.' to plugin map
  { 'tpope/vim-surround' }, -- change surrounding quotes and tags

  { 'fatih/vim-nginx', ft = 'nginx' }, -- nginx config

  -- playing around with dap/debug
  { 'rcarriga/nvim-dap-ui', dependencies = { 'mfussenegger/nvim-dap' } },
  { 'theHamsta/nvim-dap-virtual-text', dependencies = { 'mfussenegger/nvim-dap' } },

  { 'mfussenegger/nvim-jdtls' }, -- Java LSP extensions
  { 'rust-lang/rust.vim', ft = 'rust' }, -- rust stuff
  { 'jose-elias-alvarez/typescript.nvim' }, -- typescript
  { 'towolf/vim-helm' }, -- sane helm highlighting
}
