---------------------------------------------------------------------
-- Language Server Protocol
---------------------------------------------------------------------
require('nvim-lsp-installer').setup({
  automatic_installation = false,
  ensure_installed = {
    "bashls",
    "dockerls",
    "efm",
    "elixirls",
    "gopls",
    "sumneko_lua",
    "pylsp",
    "rust_analyzer",
    "tsserver",
    "vimls",
    "yamlls",
  },
})

-- keymaps
local function on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  -- Mappings.
  local opts = { noremap = true, silent = true }
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gh', "<Cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('v', '<leader>ca', "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap('n', '<leader>cr', '<cmd>lua vim.lsp.codelens.run()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>ll', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<leader>qf', '<cmd>lua vim.diagnostic.setqflist()<CR>', opts)

  buf_set_keymap('n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.server_capabilities.document_range_formatting then
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.document_highlight then
    vim.api.nvim_exec([[
      highlight! default link LspReferenceText  Visual
      highlight! default link LspReferenceWrite Visual
      highlight! default link LspReferenceRead  Visual
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
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return nil
  end

  for _, client in pairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
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
function _G.organize_imports(timeout_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }

  local client = get_lsp_client()
  if not client then return end

  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end

local function go_settings()
  return {
    gopls = {
      -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
      analyses = {
        fieldalignment = false,
        nilness = true,
        unusedparams = true,
        shadow = false,
      },
      buildFlags = {}, -- []string
      codelenses = {
        generate = true, -- show the `go generate` lens.
        gc_details = false, -- Show a code lens toggling the display of gc's choices.
        test = true,
        tidy = true,
      },
      directoryFilters = {}, -- []string
      gofumpt = true,
      staticcheck = true, -- experimental
      -- local = "local-imports",
    }
  }
end

local function rust_settings()
  return {
    ["rust-analyzer"] = {
      assist = {
        importMergeBehavior = "last",
        importPrefix = "by_self",
      },
      cargo = {
        loadOutDirsFromCheck = true,
      },
      checkOnSave = {
        command = "clippy",
      },
      diagnostics = {
        disabled = { "unresolved-import" },
      },
      lens = {
        -- Revisit if https://github.com/simrat39/rust-tools.nvim gets configured.
        enable = false,
      },
      procMacro = {
        enabled = true,
      },
    }
  }
end

-- Configure lua language server for neovim development
local function lua_settings()
  local runtime_path = vim.split(package.path, ';', { plain = true })
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  return {
    Lua = {
      runtime = {
        -- LuaJIT in the case of Neovim
        version = 'LuaJIT',
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
      },
      telemetry = {
        enable = false,
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

  -- nvim-cmp supports additional completion capabilities
  local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if has_cmp_nvim_lsp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  return {
    capabilities = capabilities, -- enable snippet support
    on_attach = on_attach, -- map buffer local keybindings when the language server attaches
  }
end

local function setup_servers()
  local lspconfig = require('lspconfig')
  local util = require('lspconfig.util')
  util.default_config = vim.tbl_extend(
    'force',
    util.default_config,
    make_config()
  )

  lspconfig.bashls.setup({})

  lspconfig.clangd.setup({
    filetypes = { "c", "cpp" }
  })

  lspconfig.dockerls.setup({})

  lspconfig.efm.setup({
    init_options = {
      documentFormatting = true,
      codeAction = true,
    },
    filetypes = { 'elixir', 'sh' },
    settings = efm_settings(),
  })

  lspconfig.elixirls.setup({
    settings = {
      elixirLS = {
        dialyzerEnabled = false,
        fetchDeps = false,
      }
    }
  })

  lspconfig.gopls.setup({
    -- https://github.com/ray-x/go.nvim#lsp-cmp-support
    capabilities = {
      textDocument = {
        completion = {
          completionItem = {
            commitCharactersSupport = true,
            deprecatedSupport = true,
            documentationFormat = {
              "markdown",
              "plaintext",
            },
            preselectSupport = true,
            insertReplaceSupport = true,
            labelDetailsSupport = true,
            snippetSupport = true,
            tagSupport = { valueSet = { 1 } },
            resolveSupport = {
              properties = {
                "documentation",
                "details",
                "additionalTextEdits",
              },
            },
          },
          contextSupport = true,
          dynamicRegistration = true,
        },
      },
    },
    cmd = {
      "gopls", -- share the gopls instance if there is one already
      "-remote.debug=:0",
    },
    filetypes = {
      "go",
      "gomod",
      "gohtmltmpl",
      "gotexttmpl",
    },
    settings = go_settings(),
  })

  lspconfig.pylsp.setup({})

  lspconfig.sumneko_lua.setup({
    settings = lua_settings()
  })

  lspconfig.rust_analyzer.setup({
    settings = rust_settings()
  })

  lspconfig.sourcekit.setup({
    -- we don't want c and cpp!
    filetypes = {
      "swift",
      "objective-c",
      "objective-cpp"
    }
  })

  lspconfig.vimls.setup({})

  lspconfig.yamlls.setup({
    settings = {
      redhat = { telemetry = { enabled = false } },
      yaml = {
        completion = true,
        validate = true,
        format = { enable = true },
        hover = true,
        schemaStore = {
          enable = false,
          url = "https://www.schemastore.org/api/json/catalog.json",
        },
        schemas = {
          ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.22.4-standalone-strict/all.json"] = "deploy/**/*.yaml",
        },
        trace = { server = "debug" },
      }
    }
  })

  lspconfig.tsserver.setup({})
end

-- https://np.reddit.com/r/backtickbot/comments/ng3qz4/httpsnpredditcomrneovimcommentsng0dj0lsp/
vim.g.diagnostics_active = true
function _G.toggle_diagnostics()
  if vim.g.diagnostics_active then
    vim.g.diagnostics_active = false
    vim.lsp.diagnostic.clear(0)
    vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
  else
    vim.g.diagnostics_active = true
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
    })
  end
end

vim.api.nvim_set_keymap('n', '<leader>tt', ':call v:lua.toggle_diagnostics()<CR>', { noremap = true, silent = true })

-- vim.lsp.set_log_level('trace')
setup_servers()
