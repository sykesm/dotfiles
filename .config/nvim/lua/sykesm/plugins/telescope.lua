-- telescope.lua

local function oldfiles()
  require('telescope.builtin').oldfiles()
end

local function buffers()
  require('telescope.builtin').buffers()
end

local function fuzzy_find()
  local dd = require('telescope.themes').get_dropdown({
    winblend = 10,
    previewer = false,
  })
  require('telescope.builtin').current_buffer_fuzzy_find(dd)
end

local function find_files()
  require('telescope.builtin').find_files({
    hidden = false,
  })
end

local function help_tags()
  require('telescope.builtin').help_tags()
end

local function grep_string()
  require('telescope.builtin').grep_string()
end

local function live_grep()
  require('telescope.builtin').live_grep()
end

local function diagnostics()
  require('telescope.builtin').diagnostics()
end

local M = {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  cmd = 'Telescope',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-ui-select.nvim',
      config = function()
        require('telescope').load_extension('ui-select')
      end,
    },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = vim.fn.executable('make') == 1,
      config = function()
        require('telescope').load_extension('fzf')
      end,
    },
    { 'nvim-tree/nvim-web-devicons' },
  },
  keys = {
    { '<leader>?', oldfiles, desc = '[?] Find recently opened files' },
    { '<leader><space>', buffers, desc = '[ ] Find existing buffers' },
    { '<leader>/', fuzzy_find, desc = '[/] Fuzzy search in current buffer]' },
    { '<C-p>', find_files, desc = 'Ctrl-P' },
    { '<leader>sf', find_files, '[S]earch [F]iles' },
    { '<leader>sh', help_tags, '[S]earch [H]elp' },
    { '<leader>sw', grep_string, desc = '[S]earch current [W]ord' },
    { '<leader>sg', live_grep, desc = '[S]earch by [G]rep' },
    { '<leader>sd', diagnostics, desc = '[S]earch [D]iagnostics' },
  },
}

function M.opts()
  local actions = require('telescope.actions')
  local previewers = require('telescope.previewers')
  local sorters = require('telescope.sorters')

  return {
    defaults = {
      mappings = {
        i = {
          ['<C-u>'] = false,
          ['<C-d>'] = false,
          ['<C-b>'] = actions.preview_scrolling_up,
          ['<C-f>'] = actions.preview_scrolling_down,
        },
      },
      vimgrep_arguments = {
        'ag',
        '--vimgrep',
      },
      prompt_prefix = '> ',
      selection_caret = '> ',
      entry_prefix = '  ',
      initial_mode = 'insert',
      selection_strategy = 'reset',
      sorting_strategy = 'descending',
      layout_strategy = 'flex',
      layout_config = {
        prompt_position = 'bottom',
        width = 0.90,
        flex = {
          flip_columns = 150,
          flip_lines = 24,
        },
        horizontal = {
          mirror = false,
          preview_cutoff = 90,
          preview_width = { 0.65, min = 20 },
        },
        vertical = {
          mirror = false,
          preview_cutoff = 20,
        },
      },
      file_sorter = sorters.get_fuzzy_file,
      file_ignore_patterns = {},
      generic_sorter = sorters.get_generic_fuzzy_sorter,
      dynamic_preview_title = true,
      path_display = {
        shorten = {
          len = 3,
          exclude = { -1 },
        },
        truncate = true,
      },
      winblend = 0,
      border = {},
      borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
      color_devicons = true,
      use_less = true,
      set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
      file_previewer = previewers.vim_buffer_cat.new,
      grep_previewer = previewers.vim_buffer_vimgrep.new,
      qflist_previewer = previewers.vim_buffer_qflist.new,

      -- Developer configurations: Not meant for general override
      buffer_previewer_maker = previewers.buffer_previewer_maker,
    },
    extensions = {
      ['ui-select'] = {
        require('telescope.themes').get_dropdown({}),
      },
    },
    pickers = {
      grep_string = { disable_coordinates = true },
      live_grep = { disable_coordinates = true },

      lsp_references = { fname_width = 40 },
      lsp_document_symbols = { fname_width = 40 },
      lsp_dynamic_workspace_symbols = { fname_width = 40 },
    },
  }
end

function M.config(_, opts)
  require('telescope').setup(opts)
end

return M
