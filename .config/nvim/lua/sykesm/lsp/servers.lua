-- servers.lua - LSP server configurations

--- Extended LSP server configuration
--- @class ServerLSPConfig : vim.lsp.Config
---
--- Flag that can be set to opt-out of automatic install and setup
--- @field ensure_installed? boolean

--- @type table<string, [ServerLSPConfig]|fun(lspconfig.Config)|boolean>
local server_configs = {
  angularls = {},
  bashls = {},
  cssls = {},
  dockerls = {},
  emmet_ls = {
    filetypes = {
      'css',
      'html',
      'less',
      'sass',
      'scss',
      'svelte',
      'typescript',
    },
  },
  gopls = {
    cmd = { 'gopls', '-remote.debug=:0' }, -- share the gopls instance if there is one already
    filetypes = {
      'go',
      'gomod',
      'gosum',
      'gotmpl',
      'gohtmltmpl',
      'gotexttmpl',
    },
    settings = {
      gopls = {
        -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
        analyses = {
          fieldalignment = false,
          nilness = true,
          shadow = false,
          unusedparams = true,
          S1016 = false, -- https://staticcheck.dev/docs/checks/#S1016
          ST1000 = false, -- https://staticcheck.dev/docs/checks/#ST1000
        },
        buildFlags = { '-tags=unit,integration' }, -- example: { '-tags=unit' }
        codelenses = {
          gc_details = false, -- Show a code lens toggling the display of gc's choices.
          generate = true, -- show the `go generate` lens.
          test = true,
          tidy = true,
        },
        completeUnimported = true,
        completeFunctionCalls = false, -- prevent paren insertion on completion
        directoryFilters = {
          '-**/node_modules',
        },
        gofumpt = true,
        hints = {
          constantValues = true,
        },
        staticcheck = true, -- experimental
        templateExtensions = {
          '.gotexttmpl',
          '.gohtmltmpl',
        },
        usePlaceholders = true,
        vulncheck = 'Imports',
        -- ['local'] = "",
      },
    },
  },
  html = {},
  jdtls = false, -- Install, but don't enable
  lua_ls = {
    settings = {
      Lua = {
        format = { enable = false },
        telemetry = { enable = false },
        workspace = { checkThirdParty = false },
      },
    },
  },
  rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
        cargo = {
          loadOutDirsFromCheck = true,
        },
        checkOnSave = true,
        diagnostics = {
          disabled = { 'unresolved-import' },
        },
        lens = {
          enable = false, -- Revisit if https://github.com/simrat39/rust-tools.nvim gets configured.
        },
        procMacro = {
          enabled = true,
        },
      },
    },
  },
  tailwindcss = {},
  tofu_ls = {},
  ts_ls = function(_)
    -- Empty function used to ensure that the typescript server is
    -- installed but the setup is done by typescript-tools.
  end,
  vimls = {},
  yamlls = {
    handlers = {
      -- err, result, ctx
      ['textDocument/publishDiagnostics'] = function(_, result, ctx)
        local uri = result.uri
        local fname = vim.uri_to_fname(uri)
        local bufnr = vim.fn.bufadd(fname)
        if vim.bo[bufnr].filetype == 'helm' then
          result.diagnostics = {}
        end
        vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx)
      end,
      {},
    },
    settings = {
      redhat = {
        telemetry = { enabled = false },
      },
      yaml = {
        completion = true,
        format = { enable = true },
        hover = true,
        schemas = {
          ['https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.6-standalone-strict/all.json'] = 'deploy/**/*.yaml',
        },
        schemaStore = {
          enable = false,
          url = 'https://www.schemastore.org/api/json/catalog.json',
        },
        trace = { server = 'debug' },
        validate = true,
      },
    },
  },
}

return server_configs
