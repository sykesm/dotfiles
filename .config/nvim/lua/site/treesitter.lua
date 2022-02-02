---------------------------------------------------------------------
-- Treesitter
---------------------------------------------------------------------
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "c",
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
    enable = true,   -- false will disable the whole extension
    disable = {      -- list of languages to disabled
      "elixir",
    },
  },
  indent = {
    enable = false,
  },
  playground = {
    enable = true,
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = {"BufWrite", "CursorHold"},
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
  },
}
