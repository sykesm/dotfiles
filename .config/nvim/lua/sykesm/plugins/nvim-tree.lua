-- nvim-tree.lua

-- Most of the code that's in here exists to try to make nvim-tree behave
-- like NerdTree and neo-tree when opening a file after a split. Out of the
-- box, the window needs to be manually selected. If that's disabled, the
-- picker uses the window caused the file tree to open, not the window that
-- was active before entering the file tree.
--
-- This uses a somewhat hacky solution that's cobled together from GitHub
-- issues and code that lives in neo-tree. The idea is to register an autocmd
-- for WinLeave and use that to maintain a list of the last several windows
-- that have been used. When it's time to select one, the most recently visited
-- "valid" window is used.

local previous_windows_by_tabpage = {}

local ignored_file_type = {
  ['NvimTree'] = true,
}

local ignored_buffer_type = {
  ['nofile'] = true,
  ['terminal'] = true,
  ['help'] = true,
}

local function is_floating(window)
  local cfg = vim.api.nvim_win_get_config(window)
  if cfg.relative > '' or cfg.external then
    return true
  end
  return false
end

local function is_ignored_window(window)
  window = window or vim.api.nvim_get_current_win()
  if is_floating(window) then
    return true
  end
  local buf = vim.api.nvim_win_get_buf(window)
  local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
  if ignored_file_type[ft] then
    return true
  end
  local bt = vim.api.nvim_get_option_value('buftype', { buf = buf })
  if ignored_buffer_type[bt] then
    return true
  end
  return false
end

local function remove_invalid_windows(wins)
  local active = {}
  for _, w in ipairs(wins) do
    if vim.api.nvim_win_is_valid(w) then
      table.insert(active, w)
    end
  end
  if #active > 50 then
    local remaining = {}
    for i = #active - 25, #active do
      table.insert(remaining, active[i])
    end
    active = remaining
  end
  return active
end

local function remove_invalid(mapping)
  for t, wins in pairs(mapping) do
    if not vim.api.nvim_tabpage_is_valid(t) then
      mapping[t] = nil
    else
      mapping[t] = remove_invalid_windows(wins)
    end
  end
end

local function win_leave_callback(_)
  local tabpage = vim.api.nvim_get_current_tabpage()
  local window = vim.api.nvim_get_current_win()
  if is_floating(window) or is_ignored_window(window) then
    return
  end

  -- track previous windows
  previous_windows_by_tabpage[tabpage] = previous_windows_by_tabpage[tabpage] or {}
  table.insert(previous_windows_by_tabpage[tabpage], window)

  -- tidy closed windows/tabs
  remove_invalid(previous_windows_by_tabpage)
end

local function window_picker()
  local tabid = vim.api.nvim_get_current_tabpage()
  local prev_windows = previous_windows_by_tabpage[tabid]
  if not prev_windows then
    return nil
  end
  local window = prev_windows[#prev_windows]
  return window
end

local M = {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  cmd = {
    'NvimTreeOpen',
    'NvimTreeToggle',
    'NvimTreeFocus',
    'NvimTreeFindFile',
  },
  keys = {
    { '<leader>n', '<cmd>NvimTreeToggle<cr>', desc = 'Toggle NvimTree' },
    { '<F9>', '<cmd>NvimTreeFindFile!<cr>', desc = 'Show file in NvimTree' },
  },
  opts = {
    actions = {
      open_file = {
        window_picker = {
          enable = true,
          picker = window_picker,
        },
      },
    },
    diagnostics = {
      enable = true,
    },
    renderer = {
      group_empty = true,
      indent_markers = {
        enable = true,
      },
      icons = {
        git_placement = 'after',
        glyphs = {
          git = {
            untracked = '󰄱',
          },
        },
      },
    },
    view = {
      width = {
        min = 30,
        max = '25%',
      },
    },
    on_attach = function(bufnr)
      local nvim_tree = require('nvim-tree.api')
      local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      nvim_tree.config.mappings.default_on_attach(bufnr)
      vim.keymap.set('n', '?', nvim_tree.tree.toggle_help, opts('Help'))
    end,
  },
}

function M.config(_, opts)
  require('nvim-tree').setup(opts)
  vim.api.nvim_create_autocmd({ 'WinLeave' }, {
    callback = win_leave_callback,
  })
end

return M
