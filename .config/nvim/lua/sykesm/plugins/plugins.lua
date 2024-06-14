return {
  { 'tpope/vim-repeat' }, -- extend '.' to plugin map

  { 'fatih/vim-nginx', ft = 'nginx' }, -- nginx config
  { 'rust-lang/rust.vim', ft = 'rust' }, -- rust stuff
  { 'towolf/vim-helm', ft = 'helm' }, -- sane helm highlighting
  { 'jose-elias-alvarez/typescript.nvim' }, -- typescript

  -- playing around with dap/debug
  { 'rcarriga/nvim-dap-ui', dependencies = { 'mfussenegger/nvim-dap' } },
  { 'theHamsta/nvim-dap-virtual-text', dependencies = { 'mfussenegger/nvim-dap' } },
}
