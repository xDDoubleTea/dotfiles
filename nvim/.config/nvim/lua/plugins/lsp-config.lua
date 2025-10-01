return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    ---@type lspconfig.options
    inlay_hints = {
      enabled = false,
    },
  },
  servers = {
    matlab_ls = {
      cmd = { "matlab-language-server", "--stdio" },
      matlab = {
        indexWorkspace = true,
        installPath = "",
      },
      single_file_support = true,
    },
  },
}
