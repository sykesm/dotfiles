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
  ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,  -- false will disable the whole extension
    disable = { },  -- list of language that will be disabled
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
}
