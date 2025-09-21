-- treesitter.lua

local M = {
  {
    'nvim-treesitter/nvim-treesitter', -- AST based syntax highlighting and navigation
    build = function()
      require('nvim-treesitter.install').update({
        with_sync = true,
      })
    end,
    event = { 'BufReadPre', 'BufNewFile', 'VeryLazy' },
    lazy = vim.fn.argc(-1) == 0,
    init = function(plugin)
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer triggers the **nvim-treesitter** module to be loaded in time.
      require('lazy.core.loader').add_to_rtp(plugin)
      require('nvim-treesitter.query_predicates')
    end,
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'css',
        'diff',
        'elixir',
        'glimmer',
        'go',
        'gomod',
        'gosum',
        'gowork',
        'graphql',
        'hcl',
        'html',
        'java',
        'javascript',
        'json',
        'jsonc',
        'kotlin',
        'lua',
        'markdown',
        'markdown_inline',
        'python',
        'ruby',
        'rego',
        'rust',
        'sql',
        'query',
        'toml',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      },
      ignore_install = { -- List of parsers to ignore installing
        'comment', -- Experiment to see how this chages rendering
      },
      highlight = {
        enable = true, -- false will disable the whole extension
        additional_vim_regex_highlighting = false,
        disable = {
          'comment', -- Experiment to see how this chages rendering
        },
      },
      indent = {
        enable = false,
      },
      matchup = {
        enable = true,
        disable = {}, -- "c", "ruby"
        disable_virtual_text = false,
        include_match_words = false,
      },
      playground = {
        enable = true,
      },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { 'BufWrite', 'CursorHold' },
      },
      rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = 10000,
        colors = {
          '#fc514e',
          '#a1cd5e',
          '#e3d18a',
          '#82aaff',
          '#c792ea',
          '#7fdbca',
          '#a1aab8',
        },
      },
      textobjects = { -- syntax-aware textobjects
        enable = true,
        lsp_interop = {
          enable = true,
          peek_definition_code = {
            ['<leader>df'] = '@function.outer',
            ['<leader>dF'] = '@class.outer',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = { 'BufReadPre', 'BufNewFile', 'VeryLazy' },
  },
}

return M
