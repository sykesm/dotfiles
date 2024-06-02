-- nvim-telescope.lua

local telescope_ok, telescope = pcall(require, 'telescope')
if not telescope_ok then
  return
end

local actions_ok, actions = pcall(require, 'telescope.actions')
if not actions_ok then
  return
end

telescope.setup({
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
    file_sorter = require('telescope.sorters').get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
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
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
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
})

telescope.load_extension('ui-select')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = '[/] Fuzzy search in current buffer]' })

vim.keymap.set('n', '<C-p>', function()
  require('telescope.builtin').find_files({ hidden = false })
end, { desc = 'Ctrl-P' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
