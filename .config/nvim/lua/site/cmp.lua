-- compe was deprecated and this is the replacement.
--
-- The wiki has some information about getting it to work like supertab
-- but I've had some issues getting it to work. Things became even more
-- broken with copilot so I'm bailing on tab completion for now.
--
-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#vim-vsnip has
-- outlines the configuration if I ever get around to it.

local cmp = require('cmp')
cmp.setup {
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer', keyword_length = 5, max_item_count = 10 },
    { name = 'path' },
    { name = 'vsnip' },
  },
}
