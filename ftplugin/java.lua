local jdtls = require 'jdtls'
local root_markers = { 'gradlew', 'mvnw', '.git' }
local root_dir = require('jdtls.setup').find_root(root_markers)
local home = os.getenv 'HOME'
local workspace_folder = home .. '/.local/share/eclipse/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')
local path_to_jdtls = '/opt/homebrew/Cellar/jdtls/1.33.0/libexec'
local lombok_path = home .. '/.m2/repository/org/projectlombok/lombok/1.18.30/lombok-1.18.30.jar'

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    '/Users/mirko/.sdkman/candidates/java/17.0.5-amzn/bin/java',

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-javaagent:' .. lombok_path,
    '-Xmx4g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',

    -- 💀
    '-jar',
    vim.fn.glob(path_to_jdtls .. '/plugins/org.eclipse.equinox.launcher_*.jar'),

    -- 💀
    '-configuration',
    vim.fn.glob(path_to_jdtls .. '/config_mac_arm'),

    -- 💀
    -- See `data directory configuration` section in the README
    '-data',
    workspace_folder,
  },

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = root_dir,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      configuration = {
        runtimes = {
          {
            name = 'JavaSE-17',
            path = '/Users/mirko/.sdkman/candidates/java/17.0.5-amzn',
          },
        },
      },
      format = {
        enabled = false,
      },
      jdt = {
        ls = {
          lombokSupport = { enabled = true },
          protobufSupport = { enabled = true },
        },
      },
      maven = {
        downloadSources = true,
      },
    },
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {},
  },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(config)
