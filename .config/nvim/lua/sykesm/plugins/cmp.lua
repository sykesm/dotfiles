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
      version = '~2.0',
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

  local function cmp_mapping()
    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    local mapping = {
      ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
      ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-y>'] = cmp.mapping.confirm({ select = true }),
      ['<C-e>'] = cmp.mapping.close(),
      ['<C-Space>'] = cmp.mapping.complete({}),
    }

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

    mapping['<CR>'] = cmp.mapping({
      i = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
          fallback()
        end
      end,
      s = cmp.mapping.confirm({ select = true }),
      c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    })

    mapping['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item(cmp_select)
      else
        fallback()
      end
    end, { 'i', 's' })

    mapping['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(cmp_select)
      else
        fallback()
      end
    end, { 'i', 's' })

    return mapping
  end

  cmp.setup({
    completion = {
      completeopt = 'menu,menuone,noinsert,noselect',
    },
    confirmation = {
      default_behavior = cmp.ConfirmBehavior.Insert,
      get_commit_characters = function(commit_characters)
        if vim.bo.ft == 'go' then
          return vim.fn.extend({ '.', ',', '(', '[', ' ' }, commit_characters or {})
        end
        return commit_characters
      end,
    },
    experimental = {
      ghost_text = false,
    },
    mapping = cmp.mapping.preset.insert(cmp_mapping()),
    preselect = cmp.PreselectMode.None,
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer', keyword_length = 5, max_item_count = 10 },
      { name = 'path' },
    }),
  })

  cmp.setup.filetype({ 'markdown', 'gitcommit' }, {
    sources = {
      { name = 'path' },
      { name = 'buffer' },
    },
  })
end

return M
