-- jdtls.lua

local function shell_error()
  return vim.v.shell_error ---@diagnostic disable-line: undefined-field
end

local function java_home_macos(version)
  local java_home = '/usr/libexec/java_home'
  if not vim.fn.has('macunix') then
    return nil
  end
  if not vim.fn.executable(java_home) then
    return nil
  end

  local command = { java_home, '-F' }
  if version then
    table.insert(command, '-v')
    table.insert(command, version)
  end

  local home = vim.fn.system(command)
  if shell_error() ~= 0 then
    return nil
  end

  return string.gsub(home, '[\r\n]+$', '')
end

local function java_runtimes()
  local jdks = {
    { name = 'JavaSE-1.8', version = 8 },
    { name = 'JavaSE-9', version = 9 },
    { name = 'JavaSE-10', version = 10 },
    { name = 'JavaSE-11', version = 11 },
    { name = 'JavaSE-12', version = 12 },
    { name = 'JavaSE-13', version = 13 },
    { name = 'JavaSE-14', version = 14 },
    { name = 'JavaSE-15', version = 15 },
    { name = 'JavaSE-16', version = 16 },
    { name = 'JavaSE-17', version = 17 },
    { name = 'JavaSE-18', version = 18 },
    { name = 'JavaSE-19', version = 19 },
  }

  local runtimes = {}
  for _, jdk in ipairs(jdks) do
    local home = java_home_macos(jdk.version)
    if home ~= nil then
      table.insert(runtimes, { name = jdk.name, path = home })
    end
  end
  return runtimes
end

local function jdt_bundles()
  local mason_registry_ok, mason_registry = pcall(require, 'mason-registry')
  if not mason_registry_ok then
    return {}
  end

  local bundles = {}
  for _, package in ipairs({ 'java-debug-adapter', 'java-test' }) do
    if mason_registry.is_installed(package) then
      local install_dir = mason_registry.get_package(package):get_install_path()
      for jar in vim.fn.glob(install_dir .. '/**/*.jar'):gmatch('[^\r\n]+') do
        table.insert(bundles, jar)
      end
    end
  end

  return bundles
end

-- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
local function config()
  local jdtls_ok, _ = pcall(require, 'jdtls')
  if not jdtls_ok then
    return {}
  end

  return {
    cmd = require('lspconfig').jdtls.document_config.default_config.cmd,
    cmd_env = {
      JAVA_HOME = java_home_macos(),
    },
    on_attach = function(client, bufnr)
      require('sykesm.plugins.lsp.on-attach')(client, bufnr)
      require('jdtls.setup').add_commands()
      require('jdtls').setup_dap({ hotcodereplace = 'auto' })
    end,
    capabilities = require('sykesm.plugins.lsp.capabilities').create(),
    root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
    settings = {
      java = {
        signatureHelp = { enabled = true },
        contentProvider = { preferred = 'fernflower' },
        eclipse = {
          downloadSources = true,
        },
        maven = { downloadSources = true },
        implementationsCodeLens = { enabled = true },
        referencesCodeLens = { enabled = true },
        references = { includeDecompiledSources = true },
        inlayHints = {
          parameterNames = { enabled = 'all' }, -- literals, all, none
        },
        completion = {
          favoriteStaticMembers = {
            'org.hamcrest.MatcherAssert.assertThat',
            'org.hamcrest.Matchers.*',
            'org.hamcrest.CoreMatchers.*',
            'org.junit.jupiter.api.Assertions.*',
            'java.util.Objects.requireNonNull',
            'java.util.Objects.requireNonNullElse',
            'org.mockito.Mockito.*',
          },
          filteredTypes = {
            'com.sun.*',
            'io.micrometer.shaded.*',
            'java.awt.*',
            'jdk.*',
            'sun.*',
          },
        },
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        codeGeneration = {
          toString = {
            template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
          },
          hashCodeEquals = {
            useJava7Objects = true,
          },
          useBlocks = true,
        },
        configuration = {
          updateBuildConfiguration = 'interactive',
          runtimes = java_runtimes(),
        },
      },
    },
    init_options = {
      bundles = jdt_bundles(),
    },
  }
end

local M = {}

function M.config()
  return config()
end

return M
