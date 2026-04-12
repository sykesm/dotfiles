-- treesitter.lua

local ensure_installed = {
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
  'kotlin',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'rego',
  'ruby',
  'rust',
  'sql',
  'toml',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

local function missing_parsers()
  local installed = require('nvim-treesitter.config').get_installed()
  return vim
    .iter(ensure_installed)
    :filter(function(p)
      return not vim.tbl_contains(installed, p)
    end)
    :totable()
end

---@return boolean
local function install_treesitter_cli()
  if vim.fn.exepath('tree-sitter') ~= '' then
    return true
  end

  local pkg = require('mason-registry').get_package('tree-sitter-cli')
  if not pkg:is_installed() then
    local completed = nil
    pkg:install(nil, function(success, _)
      completed = success
    end)
    vim.wait(10 * 1000, function()
      return completed ~= nil
    end, 100)
    return completed == true
  end
  return false
end

local function install_missing_parsers()
  local missing = missing_parsers()
  if #missing == 0 then
    return
  end
  if not install_treesitter_cli() then
    print('tree-sitter-cli is not available')
    return
  end
  require('nvim-treesitter').install(missing):wait(60 * 1000)
end

local M = {
  {
    'nvim-treesitter/nvim-treesitter', -- AST based syntax highlighting and navigation
    branch = 'main',
    dependencies = { 'mason-org/mason.nvim' },
    event = { 'BufReadPost', 'BufNewFile', 'VeryLazy' },

    ---@param _ LazyPlugin
    build = function(_)
      require('nvim-treesitter').update({ summary = true })
    end,

    ---@param _ LazyPlugin
    ---@param opts TSConfig
    ---@diagnostic disable-next-line: unused-local
    config = function(_, opts)
      install_missing_parsers()

      local group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        desc = 'Enable Treesitter highlighting',
        pattern = '*',
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          local lang = vim.treesitter.language.get_lang(ft) or ft
          pcall(vim.treesitter.start, args.buf, lang)
        end,
      })
      local ts = require('nvim-treesitter')
      ts.setup(opts)
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = { 'BufReadPre', 'BufNewFile', 'VeryLazy' },
    opts = {},
  },
}

return M
