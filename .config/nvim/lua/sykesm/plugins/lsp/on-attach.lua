-- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save#sync-formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts
local lsp_format_group = vim.api.nvim_create_augroup('LspFormatting', {})

local lsp_format = function(bufnr)
  vim.lsp.buf.format({
    bufnr = bufnr,
    filter = function(client)
      return client.name ~= 'tsserver'
    end,
  })
end

local lsp_doc_highlight_group = vim.api.nvim_create_augroup('LSPDocumentHighlight', {})

local function on_attach(client, bufnr)
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local keymap = function(mode, keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
  end

  local tsb_ok, tsb = pcall(require, 'telescope.builtin')
  if not tsb_ok then
    tsb = nil
  end

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  keymap('n', 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  keymap('n', 'gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  keymap('n', 'K', vim.lsp.buf.hover, 'Hover Documentation')
  keymap('n', 'gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  keymap('n', '<leader>si', vim.lsp.buf.signature_help, '[S][i]gnature Help')
  keymap('n', '<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  keymap('n', '<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  keymap('n', '<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  keymap('n', '<leader>cr', vim.lsp.codelens.run, '[C]odelens [R]un')
  if tsb then
    keymap('n', 'gr', tsb.lsp_references, '[G]oto [R]eferences')
  else
    keymap('n', 'gr', vim.lsp.buf.references, '[G]oto [R]eferences')
  end
  keymap('n', '<leader>e', vim.diagnostic.open_float, '[E]rrors')
  keymap('n', '[d', vim.diagnostic.goto_prev, 'Previous [D]iagnostic')
  keymap('n', ']d', vim.diagnostic.goto_next, 'Next [D]iagnostic')
  keymap('n', '<leader>ll', vim.diagnostic.setloclist, 'Set [L]ocation [L]ist')
  keymap('n', '<leader>qf', vim.diagnostic.setqflist, 'Set [Q]uick [F]ix List')

  if tsb then
    keymap('n', '<leader>ds', tsb.lsp_document_symbols, '[D]ocument [S]ymbols')
    keymap('n', '<leader>ws', tsb.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  end

  keymap('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  keymap('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  keymap('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [List] Folders')

  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.documentFormattingProvider then
    keymap('n', '<leader>f', vim.lsp.buf.format, '[F]ormat')
    vim.api.nvim_clear_autocmds({ group = lsp_format_group, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = lsp_format_group,
      buffer = bufnr,
      callback = function()
        lsp_format(bufnr)
      end,
    })
  end
  if client.server_capabilities.documentRangeFormattingProvider then
    keymap('v', '<leader>f', vim.lsp.buf.format, '[F]ormat')
  end

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_clear_autocmds({ group = lsp_doc_highlight_group, buffer = bufnr })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = lsp_doc_highlight_group,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      group = lsp_doc_highlight_group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

return on_attach
