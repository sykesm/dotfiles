-- vim-hashicorp-tools.lua

return {
  'hashivim/vim-hashicorp-tools',
  config = function()
    vim.g.terraform_align = 1
    vim.g.terraform_fmt_on_save = 1
  end,
}
