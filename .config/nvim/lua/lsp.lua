---------------------------------------------------------------------
-- Language Server Protocol
-- https://github.com/kabouzeid/nvim-lspinstall/wiki
---------------------------------------------------------------------
-- keymaps
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<space>S', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- -- Set autocommands conditional on server_capabilities
  -- if client.resolved_capabilities.document_highlight then
  --   vim.api.nvim_exec([[
  --   augroup lsp_document_highlight
  --   autocmd! * <buffer>
  --   autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
  --   autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
  --   augroup END
  --   ]], false)
  -- end
end

-----------------------------------------------------------------------
---- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#imports
-----------------------------------------------------------------------
--function goimports(timeout_ms)
--  local context = { source = { organizeImports = true } }
--  vim.validate { context = { context, "t", true } }

--  local params = vim.lsp.util.make_range_params()
--  params.context = context

--  -- See the implementation of the textDocument/codeAction callback
--  -- (lua/vim/lsp/handler.lua) for how to do this properly.
--  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
--  if not result or next(result) == nil then return end
--  local actions = result[1].result
--  if not actions then return end
--  local action = actions[1]

--  -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
--  -- is a CodeAction, it can have either an edit, a command or both. Edits
--  -- should be executed first.
--  if action.edit or type(action.command) == "table" then
--    if action.edit then
--      vim.lsp.util.apply_workspace_edit(action.edit)
--    end
--    if type(action.command) == "table" then
--      vim.lsp.buf.execute_command(action.command)
--    end
--  else
--    vim.lsp.buf.execute_command(action)
--  end
--end

local go_settings = {
  -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
  gopls = {
    -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
    analyses = {
      fieldalignment = true,
      nilness = true,
      unusedparams = true,
    },
    buildFlags = {},       -- []string
    -- env = {},              -- map[string]string
    directoryFilters = {}, -- []string
    gofumpt = false,       -- goimports by default?
    staticcheck = true,    -- experimental
  },
}

-- Configure lua language server for neovim development
local lua_settings = {
  Lua = {
    runtime = {
      -- LuaJIT in the case of Neovim
      version = 'LuaJIT',
      path = vim.split(package.path, ';'),
    },
    diagnostics = {
      -- Get the language server to recognize the `vim` global
      globals = {'vim'},
    },
    workspace = {
      -- Make the server aware of Neovim runtime files
      library = {
        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
      },
    },
  }
}

-- config that activates keymaps and enables snippet support
local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return {
    capabilities = capabilities, -- enable snippet support
    on_attach = on_attach,       -- map buffer local keybindings when the language server attaches
  }
end

local required_language_servers = {
  "bash",
  "dockerfile",
  "go",
  "lua",
  "python",
  "rust",
  "typescript",
  "vim",
  "yaml",
}

-- lsp-install
local function setup_servers()
  local lspinstall = require('lspinstall')
  lspinstall.setup()

  -- get all installed servers and add manually installed servers
  local servers = lspinstall.installed_servers()
  table.insert(servers, "clangd")
  table.insert(servers, "sourcekit")

  -- install missing language servers
  for _, server in pairs(required_language_servers) do
    if not lspinstall.is_server_installed(server) then
      lspinstall.install_server(server)
    end
  end

  local lspconfig = require('lspconfig')
  for _, server in pairs(servers) do
    local config = make_config()

    -- language specific config
    if server == "go" then
      config.settings = go_settings
    elseif server == "lua" then
      config.settings = lua_settings
    end
    if server == "sourcekit" then
      config.filetypes = {"swift", "objective-c", "objective-cpp"}; -- we don't want c and cpp!
    end
    if server == "clangd" then
      config.filetypes = {"c", "cpp"}; -- we don't want objective-c and objective-cpp!
    end

    lspconfig[server].setup(config)
  end

end

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require('lspinstall').post_install_hook = function ()
  setup_servers()    -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

setup_servers()
