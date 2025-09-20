-- nvim-jdtls.lua

local M = {
  'mfussenegger/nvim-jdtls',
  dependencies = {
    'mfussenegger/nvim-dap',
  },
  ft = { 'java' },
  cmd = {
    'JdtBytecode',
    'JdtCompile',
    'JdtJol',
    'JdtJshell',
    'JdtRestart',
    'JdtSetRuntime',
    'JdtShowLogs',
    'JdtShowMavenActiveProfiles',
    'JdtUpdateConfig',
    'JdtUpdateDebugConfig',
    'JdtUpdateHotcode',
    'JdtUpdateMavenActiveProfiles',
    'JdtWipeDataAndRestart',
  },
}

local function shell_error()
  return vim.v.shell_error
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
    { name = 'JavaSE-11', version = 11 },
    { name = 'JavaSE-17', version = 17 },
    { name = 'JavaSE-21', version = 21 },
    { name = 'JavaSE-25', version = 25 },
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

--- Gets a path to a package managed by Mason.
---@param pkg string
---@param path? string
local function get_mason_package_path(pkg, path)
  local root = vim.env.MASON or (vim.fn.stdpath('data') .. '/mason')
  local ret = root .. '/packages/' .. pkg
  if path then
    ret = ret .. '/' .. path
  end
  if not vim.uv.fs_stat(ret) then ---@diagnostic disable-line: undefined-field
    return nil
  end
  return ret
end

local function jdtls_install_path()
  return get_mason_package_path('jdtls')
end

local function jdt_bundles()
  local bundles = {}

  for _, package in ipairs({ 'java-debug-adapter', 'java-test' }) do
    local install_dir = get_mason_package_path(package)
    if install_dir then
      for jar in vim.fn.glob(install_dir .. '/**/*.jar'):gmatch('[^\r\n]+') do
        if
          not vim.endswith(jar, 'com.microsoft.java.test.runner-jar-with-dependencies.jar')
          and not vim.endswith(jar, 'jacocoagent.jar')
        then
          table.insert(bundles, jar)
        end
      end
    end
  end

  return bundles
end

local function project_root()
  local explicit_root = vim.fs.root(0, '.jdtroot')
  if explicit_root and vim.fn.filereadable(explicit_root .. '/pom.xml') then
    return explicit_root
  end
  local top_level = vim.fs.root(0, { '.git', 'mvnw', 'gradlew' })
  if top_level and vim.fn.filereadable(top_level .. '/pom.xml') then
    return top_level
  end
  if top_level and vim.fn.filereadable(top_level .. '/build.gradle') then
    return top_level
  end
  return vim.fs.root(0, { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' })
end

local function jdtls_cmd(root_dir)
  local cmd = {
    'jdtls',
    string.format('--jvm-arg=-javaagent:%s', jdtls_install_path() .. '/lombok.jar'),
  }

  local project_name = root_dir and vim.fs.basename(root_dir)
  if project_name then
    vim.list_extend(cmd, {
      '-configuration',
      vim.fn.stdpath('cache') .. '/jdtls/' .. project_name .. '/config',
      '-data',
      vim.fn.stdpath('cache') .. '/jdtls/' .. project_name .. '/workspace',
    })
  end

  return cmd
end

function M.opts()
  return {
    capabilities = require('sykesm.lsp.capabilities').create(),
    dap = {
      hotcodereplace = 'auto',
      config_overrides = {},
    },
    dap_main = {},
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
          parameterNames = {
            enabled = 'all', -- literals, all, none
          },
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
  }
end

local function setup_keymaps(_, bufnr)
  local jdtls = require('jdtls')

  local keymap = function(mode, keys, func, desc)
    if desc then
      desc = 'jdtls: ' .. desc
    end
    vim.keymap.set(mode, keys, func, { buffer = bufnr, silent = true, desc = desc })
  end

  local function save_and(f, ...)
    if vim.bo.modified then
      vim.cmd('w')
    end
    local args = { ... }
    return function()
      f(unpack(args))
    end
  end

  -- save_modified may need to be called
  keymap('n', '<leader>tc', save_and(jdtls.test_class), '[T]est [C]lass')
  keymap('n', '<leader>tn', save_and(jdtls.test_nearest_method), '[T]est [N]earest Method')
  keymap('n', '<leader>ts', save_and(jdtls.pick_test), '[T]est [S]elected')

  keymap('n', '<leader>cxv', jdtls.extract_variable_all, 'Extract Variable')
  keymap('n', '<leader>cxc', jdtls.extract_constant, 'Extract Constant')
  keymap('n', 'gs', jdtls.super_implementation, 'Goto Super')
  keymap('n', 'gS', require('jdtls.tests').goto_subjects, 'Goto Subjects')
  keymap('n', '<leader>co', jdtls.organize_imports, 'Organize Imports')
  -- keymap('v', '<leader>cxm', jdtls.extract_method(true), 'Extract Method')
  -- keymap('v', '<leader>cxv', jdtls.extract_variable_all(true), 'Extract Variable')
  -- keymap('v', '<leader>cxc', jdtls.extract_constant(true), 'Extract Constant')
end

-- May 11, 2025
-- There's an ASM compatibiltiy issue across jdtls and java test.
-- This shows up as a BundleException during startup:
--
--   org.osgi.framework.BundleException: Could not resolve module: com.microsoft.java.test.plugin [208]
--     Unresolved requirement: Require-Bundle: org.jacoco.core; bundle-version="0.8.12"
--       -> Bundle-SymbolicName: org.jacoco.core; bundle-version="0.8.12.202403310830"
--          org.jacoco.core [224]
--            Unresolved requirement: Import-Package: org.objectweb.asm; version="[9.7.0,9.8.0)"
--
-- https://open-vsx.org/extension/vscjava/vscode-java-test

function M.config(_, opts)
  local function lsp_on_attach(client, bufnr)
    -- custom init for Java debugger
    require('sykesm.lsp.on-attach')(client, bufnr)
    require('jdtls').setup_dap(opts.dap)
    require('jdtls.dap').setup_dap_main_class_configs(opts.dap_main)
    require('jdtls').settings.jdt_uri_timeout_ms = 15000
    setup_keymaps(client, bufnr)
  end

  local bundles = jdt_bundles()

  -- Callback invoked when as an ftplugin
  local function attach_jdtls()
    local root_dir = project_root()

    local config = vim.tbl_deep_extend('force', opts, {
      root_dir = root_dir,
      cmd = jdtls_cmd(root_dir),
      cmd_env = {
        JAVA_HOME = java_home_macos(21),
      },
      on_attach = lsp_on_attach,
      init_options = {
        bundles = bundles,
      },
    })
    require('jdtls').start_or_attach(config)
  end

  -- Attach the jdtls for each java buffer. HOWEVER, this plugin loads
  -- depending on filetype, so this autocmd doesn't run for the first file.
  -- For that, we call directly below.
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'java' },
    callback = attach_jdtls,
  })

  -- Avoid race condition by calling attach the first time, since the autocmd won't fire.
  attach_jdtls()
end

return M
