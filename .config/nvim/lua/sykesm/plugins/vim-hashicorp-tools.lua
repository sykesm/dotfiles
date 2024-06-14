-- vim-hashicorp-tools.lua

return {
  'hashivim/vim-hashicorp-tools',
  ft = {
    'terraform',
    'ruby', -- Vagrantfile
  },
  cmd = {
    'Consul',
    'Nomad',
    'Otto',
    'Packer',
    'Terraform',
    'TerraformFmt',
    'Vagrant',
    'Vault',
  },
  config = function()
    vim.g.terraform_align = 1
    vim.g.terraform_fmt_on_save = 1
  end,
}
