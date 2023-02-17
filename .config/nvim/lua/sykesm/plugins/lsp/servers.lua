-- servers.lua - LSP server configurations

local serverConfigs = {
  bashls = {},
  cssls = {},
  dockerls = {},
  efm = {
    filetypes = { 'elixir', 'sh' },
    init_options = {
      documentFormatting = true,
      codeAction = true,
    },
    settings = {
      rootMarkers = { '.git/' },
      languages = {
        sh = {
          {
            lintCommand = 'shellcheck -f gcc -x',
            lintSource = 'shellcheck',
            lintFormats = {
              '%f:%l:%c: %trror: %m',
              '%f:%l:%c: %tarning: %m',
              '%f:%l:%c: %tote: %m',
            },
          },
        },
        elixir = {
          {
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
          },
        },
      },
    },
  },
  emmet_ls = {
    filetypes = {
      "css",
      "html",
      "less",
      "sass",
      "scss",
      "svelte",
    },
  },
  gopls = {
    cmd = { "gopls", "-remote.debug=:0" }, -- share the gopls instance if there is one already
    filetypes = {
      "go",
      "gomod",
      "gohtmltmpl",
      "gotexttmpl",
    },
    settings = {
      gopls = {
        -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
        analyses = {
          fieldalignment = false,
          nilness = true,
          shadow = false,
          unusedparams = true,
        },
        buildFlags = {}, -- []string
        codelenses = {
          gc_details = false, -- Show a code lens toggling the display of gc's choices.
          generate = true, -- show the `go generate` lens.
          test = true,
          tidy = true,
        },
        directoryFilters = {}, -- []string
        gofumpt = true,
        staticcheck = true, -- experimental
        vulncheck = "Imports",
        -- ['local'] = "",
      }
    },
  },
  html = {},
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
          enable = false, -- Revisit if https://github.com/simrat39/rust-tools.nvim gets configured.
        },
        procMacro = {
          enabled = true,
        },
      },
    }
  },
  tailwindcss = {},
  terraformls = {},
  tsserver = {},
  vimls = {},
  yamlls = {
    settings = {
      redhat = {
        telemetry = { enabled = false }
      },
      yaml = {
        completion = true,
        format = { enable = true },
        hover = true,
        schemas = {
          ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.25.6-standalone-strict/all.json"] = "deploy/**/*.yaml",
        },
        schemaStore = {
          enable = false,
          url = "https://www.schemastore.org/api/json/catalog.json",
        },
        trace = { server = "debug" },
        validate = true,
      }
    }
  },
}

local M = {}

function M.servers()
  return serverConfigs
end

return M
