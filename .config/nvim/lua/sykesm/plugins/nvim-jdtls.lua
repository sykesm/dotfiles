-- nvim-jdtls.lua

local M = {
  'mfussenegger/nvim-jdtls',
  dependencies = {
    'williamboman/mason.nvim',
    'mfussenegger/nvim-dap',
  },
  ft = { 'java' },
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
    { name = 'JavaSE-1.8', version = 8 },
    { name = 'JavaSE-11', version = 11 },
    { name = 'JavaSE-17', version = 17 },
    { name = 'JavaSE-21', version = 21 },
    { name = 'JavaSE-22', version = 22 },
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

local function jdtls_install_path()
  return require('mason-registry').get_package('jdtls'):get_install_path()
end

local function jdt_bundles()
  local bundles = {}

  local mason_registry = require('mason-registry')
  for _, package in ipairs({ 'java-debug-adapter', 'java-test' }) do
    if mason_registry.is_installed(package) then
      local install_dir = mason_registry.get_package(package):get_install_path()
      for jar in vim.fn.glob(install_dir .. '/**/*.jar'):gmatch('[^\r\n]+') do
        if not vim.endswith(jar, 'com.microsoft.java.test.runner-jar-with-dependencies.jar') then
          table.insert(bundles, jar)
        end
      end
    end
  end

  return bundles
end

local function project_root()
  return vim.fs.root(0, { 'gradlew', 'mvnw', 'pom.xml', '.git' })
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

function M.config(_, opts)
  local function lsp_on_attach(client, bufnr)
    -- custom init for Java debugger
    require('sykesm.lsp.on-attach')(client, bufnr)
    require('jdtls').setup_dap(opts.dap)
    require('jdtls.dap').setup_dap_main_class_configs(opts.dap_main)
    setup_keymaps(client, bufnr)
  end

  -- Callback invoked when as an ftplugin
  local function attach_jdtls()
    local root_dir = project_root()

    local config = vim.tbl_deep_extend('force', opts, {
      root_dir = root_dir,
      cmd = jdtls_cmd(root_dir),
      cmd_env = {
        JAVA_HOME = java_home_macos(),
      },
      on_attach = lsp_on_attach,
      init_options = {
        bundles = jdt_bundles(),
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
