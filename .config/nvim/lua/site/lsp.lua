---------------------------------------------------------------------
-- Language Server Protocol
-- https://github.com/kabouzeid/nvim-lspinstall/wiki
---------------------------------------------------------------------
-- keymaps
local function on_attach(client, bufnr)
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
  buf_set_keymap('n', '<leader>S', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>qf', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
    augroup lsp_document_highlight
    autocmd! * <buffer>
    autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]], false)
  end
end

---------------------------------------------------------------------
-- https://github.com/neovim/neovim/issues/14618#issuecomment-846549867
---------------------------------------------------------------------
local function get_lsp_client()
  -- Get lsp client for current buffer
  local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
  local clients = vim.lsp.buf_get_clients()
  if next(clients) == nil then
    return nil
  end

  for _, client in pairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes,buf_ft) ~= -1 then
      return client
    end
  end

  return nil
end

---------------------------------------------------------------------
-- Try to invoke the source.organizeImports action on save.
--
-- This was cobbled together with some help from these links and
-- probably isn't the best implementation.
--
-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#imports
-- https://github.com/neovim/nvim-lspconfig/issues/115#issuecomment-849865673
---------------------------------------------------------------------
function _G.go_organize_imports_sync(timeout_ms)
  local context = { source = { organizeImports = true } }
  vim.validate { context = { context, "t", true } }

  local params = vim.lsp.util.make_range_params()
  params.context = context

  local client = get_lsp_client()
  if not client then return end
  local result = client.request_sync("textDocument/codeAction", params, timeout_ms, 0)
  if not result then return end
  local actions = result.result
  if not actions then return end

  for _, action in pairs(actions) do
    if action.kind and action.kind == "source.organizeImports" then
      -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
      -- is a CodeAction, it can have either an edit, a command or both. Edits
      -- should be executed first.
      if action.edit or type(action.command) == "table" then
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit)
        end
        if type(action.command) == "table" then
          vim.lsp.buf.execute_command(action.command)
        end
      else
        vim.lsp.buf.execute_command(action)
      end
    end
  end
end

local function go_settings()
  local gopls = {
    -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
    analyses = {
      fieldalignment = false,
      nilness = true,
      unusedparams = true,
    },
    buildFlags = {},       -- []string
    directoryFilters = {}, -- []string
    gofumpt = true,
    staticcheck = true,    -- experimental
  }
  -- gopls['local'] = "local-imports"
  return { gopls }
end

-- Configure lua language server for neovim development
local function lua_settings ()
  return {
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
end

local function efm_settings()
  local sh_config = {
    lintCommand = 'shellcheck -f gcc -x',
    lintSource = 'shellcheck',
    lintFormats = {
      '%f:%l:%c: %trror: %m',
      '%f:%l:%c: %tarning: %m',
      '%f:%l:%c: %tote: %m',
    },
  }

  local elixir_config = {
    lintCommand = 'MIX_ENV=test mix credo suggest --format=flycheck --read-from-stdin ${INPUT}',
    rootMarkers = {
      'mix.lock',
      'mix.exs',
    },
    lintStdin = true,
    lintFormats = {
      '%f:%l:%c: %t: %m',
      '%f:%l: %t: %m',
    },
    lintCategoryMap = {
      ['R'] = 'H', -- hint
      ['D'] = 'I', -- info
      ['F'] = 'E', -- error
      ['W'] = 'W', -- warning
    },
  }
  return {
    rootMarkers = { '.git/' },
    languages = {
      sh = { sh_config },
      elixir = { elixir_config },
    },
    -- log_level = 2,
  }
end

-- config that activates keymaps and enables snippet support
local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return {
    capabilities = capabilities, -- enable snippet support
    on_attach = on_attach,       -- map buffer local keybindings when the language server attaches
  }
end

-- lsp-install
local function setup_servers()
  local lspinstall = require('lspinstall')
  local lspconfig = require('lspconfig')

  lspinstall.setup()

  -- get all installed servers and add manually installed servers
  local servers = lspinstall.installed_servers()
  table.insert(servers, "clangd")
  table.insert(servers, "sourcekit")

  for _, server in pairs(servers) do
    local config = make_config()

    -- language specific config
    if server == "clangd" then
      config.filetypes = {"c", "cpp"}; -- we don't want objective-c and objective-cpp!
    elseif server == "efm" then
      config.init_options = { documentFormatting = true, codeAction = true }
      config.filetypes = { 'elixir', 'sh' }
      config.settings = efm_settings()
    elseif server == "elixir" then
      config.settings = {
        elixirLS = {
          dialyzerEnabled = true,
          fetchDeps = false,
        }
      }
    elseif server == "go" then
      config.settings = go_settings()
    elseif server == "lua" then
      config.settings = lua_settings()
    elseif server == "sourcekit" then
      config.filetypes = {"swift", "objective-c", "objective-cpp"}; -- we don't want c and cpp!
    elseif server == "yaml" then
      config.settings = {
        yaml = {
          schemas = { kubernetes = "*.yaml" },
        }
      }
    end

    -- print(server)
    -- print(vim.inspect(config))
    lspconfig[server].setup(config)
  end
end

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require('lspinstall').post_install_hook = function ()
  setup_servers()    -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

local required_language_servers = {
  "bash",
  "dockerfile",
  "efm",
  "elixir",
  "go",
  "lua",
  "python",
  "rust",
  "typescript",
  "vim",
  "yaml",
}

local function install_required_language_servers()
  -- install missing language servers
  local lspinstall = require('lspinstall')
  for _, server in pairs(required_language_servers) do
    if not lspinstall.is_server_installed(server) then
      lspinstall.install_server(server)
    end
  end
end

-- TODO: Find a way to make this check for requirements before installing
-- things and then create a command that does this when called instead of
-- automatically.
--
-- Right now it can be invoked with :lua InstallAllLanguageServers
_G.InstallAllLanguageServers = install_required_language_servers

-- vim.lsp.set_log_level(0)
setup_servers()
