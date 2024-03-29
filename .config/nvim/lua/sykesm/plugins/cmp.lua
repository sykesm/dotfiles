-- compe was deprecated and this is the replacement.
--
-- The wiki has some information about getting it to work like supertab
-- but I've had some issues getting it to work.
--
-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#vim-vsnip has
-- outlines the configuration if I ever get around to it.

local cmp_ok, cmp = pcall(require, 'cmp')
if not cmp_ok then
  return
end

local luasnip_ok, luasnip = pcall(require, 'luasnip')
if not luasnip_ok then
  return
end

require('luasnip.loaders.from_vscode').lazy_load()

luasnip.config.setup({})

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local function cmp_mapping()
  local mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete({}),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  }

  mapping['<Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    elseif has_words_before() then
      cmp.complete()
    else
      fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
    end
  end, { 'i', 's' })

  mapping['<S-Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, { 'i', 's' })

  return mapping
end

---@diagnostic disable-next-line missing-fields
cmp.setup({
  ---@diagnostic disable-next-line missing-fields
  completion = {
    completeopt = 'menu,menuone,noinsert,noselect',
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

---@diagnostic disable-next-line missing-fields
cmp.setup.filetype({ 'markdown', 'gitcommit' }, {
  sources = {
    { name = 'path' },
    { name = 'buffer' },
  },
})
