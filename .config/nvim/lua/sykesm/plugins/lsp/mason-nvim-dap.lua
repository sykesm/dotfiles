-- load mason-nvim-dap and setup DAP servers

local mason_nvim_dap_ok, mason_nvim_dap = pcall(require, 'mason-nvim-dap')
if not mason_nvim_dap_ok then
  return
end

mason_nvim_dap.setup({
  ensure_installed = {
    'javadbg',
    'javatest',
  },
  handlers = {},
})
