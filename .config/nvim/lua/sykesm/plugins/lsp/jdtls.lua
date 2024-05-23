-- jdtls.lua

local function shell_error()
  return vim.v.shell_error
end

local function root_dir()
  return vim.fs.dirname(vim.fs.find({ 'pom.xml', 'gradlew', '.git', 'mvnw' }, { upward = true })[1])
end

local function java_format_settings()
  local settings = vim.fn.expand('~/.config/java-format/eclipse-java-google-style.xml')
  if vim.fn.filereadable(settings) then
    return {
      profile = 'GoogleStyle',
      url = settings,
    }
  end
  return nil
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
    { name = 'JavaSE-20', version = 20 },
    { name = 'JavaSE-21', version = 21 },
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

local function jdtls_install_path()
  local mason_registry_ok, mason_registry = pcall(require, 'mason-registry')
  if not mason_registry_ok then
    return {}
  end

  return mason_registry.get_package('jdtls'):get_install_path()
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

local function save_modified()
  if vim.bo.modified then
    vim.cmd('w')
  end
end

local function jdtls_on_attach(client, bufnr)
  -- Disable if these get to be expensive
  -- client.server_capabilities.semanticTokensProvider = nil
  -- client.server_capabilities.documentHighlightProvider = nil

  require('sykesm.plugins.lsp.on-attach')(client, bufnr)

  local jdtls = require('jdtls')
  jdtls.setup_dap({
    hotcodereplace = 'auto',
    config_overrides = {},
  })

  local keymap = function(mode, keys, func, desc)
    if desc then
      desc = 'jdtls: ' .. desc
    end
    vim.keymap.set(mode, keys, func, { buffer = bufnr, silent = true, desc = desc })
  end

  keymap('n', '<leader>tc', function()
    save_modified()
    jdtls.test_class()
  end, '[T]est [C]lass')

  keymap('n', '<leader>tn', function()
    save_modified()
    jdtls.test_nearest_method()
  end, '[T]est [N]earest Method')
end

-- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
local function config()
  local jdtls_ok, _ = pcall(require, 'jdtls')
  if not jdtls_ok then
    return {}
  end

  local lombok = string.format('--jvm-arg=-javaagent:%s', jdtls_install_path() .. '/lombok.jar')
  local cmd = require('lspconfig').jdtls.document_config.default_config.cmd
  if not vim.list_contains(cmd, lombok) then
    table.insert(cmd, lombok)
  end

  return {
    cmd = cmd,
    cmd_env = {
      JAVA_HOME = java_home_macos(),
    },
    on_attach = jdtls_on_attach,
    capabilities = require('sykesm.plugins.lsp.capabilities').create(),
    root_dir = root_dir(),
    settings = {
      java = {
        signatureHelp = { enabled = true },
        contentProvider = { preferred = 'fernflower' },
        eclipse = { downloadSources = true },
        format = {
          enabled = false,
          settings = java_format_settings(),
        },
        maven = { downloadSources = true },
        implementationsCodeLens = { enabled = true },
        referencesCodeLens = { enabled = true },
        references = { includeDecompiledSources = true },
        inlayHints = {
          parameterNames = { enabled = 'all' }, -- literals, all, none
        },
        completion = {
          enabled = true,
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

local jdtls_config = nil

local M = {}

function M.config()
  if jdtls_config == nil then
    jdtls_config = config()
  end
  return jdtls_config
end

return M
