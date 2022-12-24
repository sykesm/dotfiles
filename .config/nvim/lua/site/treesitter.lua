---------------------------------------------------------------------
-- Treesitter
---------------------------------------------------------------------
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "c",
    "comment",
    "elixir",
    "go",
    "gomod",
    "graphql",
    "lua",
    "rust",
    "python",
    "ruby",
    "toml",
    "yaml"
  },
  ignore_install = { -- List of parsers to ignore installing
    "javascript",
  },
  highlight = {
    enable = true, -- false will disable the whole extension
    additional_vim_regex_highlighting = false,
    disable = { -- list of languages to disabled
      "elixir",
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
    lint_events = { "BufWrite", "CursorHold" },
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 10000,
    colors = {
      "#fc514e",
      "#a1cd5e",
      "#e3d18a",
      "#82aaff",
      "#c792ea",
      "#7fdbca",
      "#a1aab8",
    },
  },
  textobjects = {
    -- syntax-aware textobjects
    enable = true,
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer"
      }
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },
}
