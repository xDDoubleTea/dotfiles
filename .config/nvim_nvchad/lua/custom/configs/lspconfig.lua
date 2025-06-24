local config = require("plugins.configs.lspconfig")

local on_attach = config.onattach
local capabilities = config.capabilities

local lspconfig = require("lspconfig")
lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes={"python"},
})

lspconfig.clangd.setup{
  on_attach = on_attach,
  capabilities = capabilities
}
