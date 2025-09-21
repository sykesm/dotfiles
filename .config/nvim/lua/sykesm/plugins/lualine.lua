--  lualine.lua

local symbols = {
  colnr = '\u{e0a3}:', -- 
  linenr = '\u{e0a1}:', -- 
  maxlinenr = '\u{2261} ', -- ☰
}

local function progress_location()
  local line = vim.fn.line('.')
  local col = vim.fn.virtcol('.')
  local total = vim.fn.line('$')
  local percent = math.floor(line / total * 100) .. '%%'
  return string.format('%s %s%d/%d%s%s%d', percent, symbols.linenr, line, total, symbols.maxlinenr, symbols.colnr, col)
end

local function encoding_fileformat()
  local fe = vim.opt.fileencoding:get()
  local ff = vim.bo.fileformat
  return string.format('%s[%s]', fe, ff)
end

local M = {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    options = {
      disabled_filetypes = {
        'NvimTree',
        'neo-tree',
      },
      refresh = {
        statusline = 200,
      },
    },
    sections = {
      lualine_b = {
        'branch',
        'diff',
        {
          'diagnostics',
          symbols = { error = ' ', hint = ' ', info = ' ', warn = ' ' },
        },
      },
      lualine_x = { 'filetype', encoding_fileformat },
      lualine_y = {},
      lualine_z = { progress_location },
    },
  },
}

return M
