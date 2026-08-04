local settings = require("settings")
local engines = settings.window.search_engines
engines.duckduckgo = "https://duckduckgo.com/?q=%s"
engines.default = engines.duckduckgo
