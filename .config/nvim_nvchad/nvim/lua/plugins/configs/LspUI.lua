local LspUI = require("LspUI")
local lsp_ui_config = require("LspUI.config")
local default_transparency = 60
lsp_ui_config.hover_setup({ transparency = default_transparency })
LspUI.setup()
