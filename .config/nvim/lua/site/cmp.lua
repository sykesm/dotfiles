-- compe was deprecated and this is the replacement.
--
-- The wiki has some information about getting it to work like supertab
-- but I've had some issues getting it to work. Things became even more
-- broken with copilot so I'm bailing on tab completion for now.
--
-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#vim-vsnip has
-- outlines the configuration if I ever get around to it.

local cmp = require('cmp')

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local function feedkey(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local function cmp_mapping()
  local mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  }

  if vim.g.copilot_enabled and vim.api.nvim_get_var('copilot_enabled') == 0 then
    mapping['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn['vsnip#available'](1) == 1 then
        feedkey('<Plug>(vsnip-expand-or-jump)', '')
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { 'i', 's' })

    mapping['<S-Tab>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        feedkey('<Plug>(vsnip-jump-prev)', '')
      end
    end, { 'i', 's' })
  end

  return mapping
end

cmp.setup {
  completion = {
    completeopt = 'menu,menuone,noinsert,noselect',
  },
  mapping = cmp.mapping.preset.insert(cmp_mapping()),
  preselect = cmp.PreselectMode.None,
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer', keyword_length = 5, max_item_count = 10 },
    { name = 'path' },
    { name = 'vsnip' },
  },
}
