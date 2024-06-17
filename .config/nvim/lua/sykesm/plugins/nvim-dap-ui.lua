-- nvim-dap-ui.lua

local M = {
  'rcarriga/nvim-dap-ui',
  dependencies = {
    'mfussenegger/nvim-dap',
    'nvim-neotest/nvim-nio',
  },
  -- stylua: ignore
  keys = {
    { '<leader>du', function() require('dapui').toggle({}) end, desc = 'Dap UI' },
    { '<leader>de', function() require('dapui').eval() end, desc = 'Eval', mode = { 'n', 'v' } },
  },
  config = function(_, opts)
    local dap = require('dap')
    local dapui = require('dapui')
    dapui.setup(opts)
    dap.listeners.after.event_initialized.dapui_config = function()
      dapui.open({})
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close({})
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close({})
    end
  end,
}

return M
