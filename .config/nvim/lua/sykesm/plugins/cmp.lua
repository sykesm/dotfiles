-- compe was deprecated and this is the replacement.

local M = {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-buffer', -- comletion from buffers
    'hrsh7th/cmp-nvim-lsp', -- LSP completion
    'hrsh7th/cmp-nvim-lsp-signature-help', -- LSP signature information
    'hrsh7th/cmp-path', -- completion from paths
    'saadparwaiz1/cmp_luasnip', -- completion from snippets
    {
      'L3MON4D3/LuaSnip', -- snippets engine
      version = '*',
      build = 'make install_jsregexp',
      cond = vim.fn.executable('make') == 1,
      dependencies = {
        'rafamadriz/friendly-snippets',
      },
      config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
    },
  },
}

function M.config()
  local cmp = require('cmp')
  local luasnip = require('luasnip')

  luasnip.config.setup({})

  local function has_words_before()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
  end

  local function cmp_mapping()
    local select_opts = { behavior = cmp.SelectBehavior.Insert }
    local mapping = {
      ['<C-n>'] = cmp.mapping.select_next_item(select_opts),
      ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<C-y>'] = cmp.mapping.confirm({ select = true }),
      ['<C-Space>'] = cmp.mapping.complete(),
    }

    mapping['<CR>'] = cmp.mapping({
      i = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false })
        else
          fallback()
        end
      end,
      s = cmp.mapping.confirm({ select = true }),
      c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
    })

    mapping['<C-l>'] = cmp.mapping(function()
      if luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      end
    end, { 'i', 's' })
    mapping['<C-h>'] = cmp.mapping(function()
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      end
    end, { 'i', 's' })

    mapping['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' })
    mapping['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' })

    return mapping
  end

  cmp.setup({
    completion = {
      completeopt = 'menu,menuone,noselect',
    },
    confirmation = {
      default_behavior = cmp.ConfirmBehavior.Insert,
      get_commit_characters = function(commit_characters)
        return commit_characters
      end,
    },
    experimental = {
      ghost_text = false,
    },
    formatting = {
      expandable_indicator = true,
      fields = { 'menu', 'abbr', 'kind' },
      format = function(entry, item)
        local menu_icon = {
          nvim_lsp = 'λ',
          luasnip = '⋗',
          buffer = 'Ω',
          path = '🖫',
        }

        item.menu = menu_icon[entry.source.name]
        return item
      end,
    },
    mapping = cmp.mapping.preset.insert(cmp_mapping()),
    preselect = cmp.PreselectMode.None,
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp', keyword_length = 1 },
      { name = 'nvim_lsp_signature_help' },
      { name = 'luasnip', keyword_length = 2 },
    }, {
      { name = 'buffer', keyword_length = 5, max_item_count = 10 },
      { name = 'path' },
    }),
    window = {
      documentation = cmp.config.window.bordered(),
    },
  })

  cmp.setup.filetype({ 'markdown', 'gitcommit' }, {
    sources = {
      { name = 'path' },
      { name = 'buffer' },
    },
  })
end

return M
