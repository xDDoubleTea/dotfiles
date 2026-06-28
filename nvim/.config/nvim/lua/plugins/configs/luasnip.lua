--
-- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
-- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
-- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
-- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
-- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
-- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
--
-- File: plugins/configs/luasnsip.lua
-- Description: luasnip configuration
-- Author: Kien Nguyen-Tuan <kiennt2609@gmail.com>
-- vscode format
require("luasnip.loaders.from_vscode").lazy_load({ exclude = vim.g.vscode_snippets_exclude or {} })
require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.g.vscode_snippets_path or "" })

-- snipmate format
require("luasnip.loaders.from_snipmate").load()
require("luasnip.loaders.from_snipmate").lazy_load({ paths = vim.g.snipmate_snippets_path or "" })

-- lua format
require("luasnip.loaders.from_lua").load()
require("luasnip.loaders.from_lua").lazy_load({ paths = vim.g.lua_snippets_path or "" })

vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
        if
            require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
            and not require("luasnip").session.jump_active
        then
            require("luasnip").unlink_current()
        end
    end,
})

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("markdown", {

    s(
        "def",
        fmt(
            [[
    !!! definition "{}"
        {}
    ]],
            { i(1, "Definition"), i(0) }
        )
    ),

    s(
        "thm",
        fmt(
            [[
    ???+ theorem "{}"
        {}
    ]],
            { i(1, "Theorem"), i(0) }
        )
    ),

    s(
        "ex",
        fmt(
            [[
    !!! example "{}"
        {}
    ]],
            { i(1, "Example"), i(0) }
        )
    ),

    s(
        "prob",
        fmt(
            [[
    !!! problem "{}"
        {}
    ]],
            { i(1, "Problem"), i(0) }
        )
    ),

    s(
        "exe",
        fmt(
            [[
    ??? exercise "{}"
        {}
    ]],
            { i(1, "Exercise"), i(0) }
        )
    ),
    s(
        "info",
        fmt(
            [[
    !!! info "{}"
        {}
    ]],
            { i(1, "資訊"), i(0) }
        )
    ),
    s(
        "ans",
        fmt(
            [[
    ??? exercise "{}"
        {}
    ]],
            { i(1, "答案"), i(0) }
        )
    ),
})
