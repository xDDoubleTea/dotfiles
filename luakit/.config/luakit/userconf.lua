local luakit = require("luakit")
local settings = require("settings")
local engines = settings.window.search_engines
engines.duckduckgo = "https://duckduckgo.com/?q=%s"
engines.default = engines.duckduckgo

local modes = require("modes")

modes.add_binds("normal", {
	{
		"y",
		"Yank URI",
		function(w)
			local uri = string.gsub(w.view.uri or "", " ", "%%20")
			luakit.selection.primary = uri
			luakit.selection.clipboard = uri
			w:notify("Yanked uri: " .. uri)
		end,
	},
})

modes.add_binds("normal", {
	{
		"<Control-c>",
		"Copy selected text.",
		function()
			luakit.selection.clipboard = luakit.selection.primary
		end,
	},
})
