-- servers.lua - LSP server configurations

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
        },
        buildFlags = {}, -- example: { '-tags=unit' }
        codelenses = {
          gc_details = false, -- Show a code lens toggling the display of gc's choices.
          generate = true, -- show the `go generate` lens.
          test = true,
          tidy = true,
        },
        directoryFilters = {}, -- []string
        gofumpt = true,
        staticcheck = true, -- experimental
        templateExtensions = {
          '.gotexttmpl',
          '.gohtmltmpl',
        },
        vulncheck = 'Imports',
        -- ['local'] = "",
      },
    },
  },
  html = {},
  jdtls = function(_) end, -- Java setup is done out of the file type plugin
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
        assist = {
          importMergeBehavior = 'last',
          importPrefix = 'by_self',
        },
        cargo = {
          loadOutDirsFromCheck = true,
        },
        checkOnSave = {
          command = 'clippy',
        },
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
  terraformls = {},
  tsserver = function(config)
    local typescript_ok, typescript = pcall(require, 'typescript')
    if not typescript_ok then
      return
    end
    typescript.setup({ debug = false, server = config })
  end,
  vimls = {},
  yamlls = {
    handlers = {
      ['textDocument/publishDiagnostics'] = vim.lsp.with(function(_, result, ctx, config)
        local uri = result.uri
        local fname = vim.uri_to_fname(uri)
        local bufnr = vim.fn.bufadd(fname)
        if vim.bo[bufnr].filetype == 'helm' then
          result.diagnostics = {}
        end
        vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
      end, {}),
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
          ['https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.25.6-standalone-strict/all.json'] = 'deploy/**/*.yaml',
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
