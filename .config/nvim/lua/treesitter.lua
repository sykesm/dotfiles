---------------------------------------------------------------------
-- Treesitter
---------------------------------------------------------------------
require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "go", "gomod", "rust", "python", "ruby" },
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
}
