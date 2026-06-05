local ascii = require("ascii")
local custom_header = ascii.art.planets.planets.saturn
return {
    "nvimdev/dashboard-nvim",
    lazy = false,
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("dashboard").setup({
            theme = "hyper",
            hide = {
                statusline = true, -- hide statusline default is true
                tabline = true, -- hide the tabline
                winbar = true, -- hide winbar
            },
            config = {
                -- week_header = { enable = true },
                header = custom_header,
                -- header = {
                --     "",
                --     " ███╗   ██║███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
                --     " ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
                --     " ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
                --     " ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
                --     " ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
                --     " ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
                --     "",
                -- },
                shortcut = {
                    {
                        action = 'lua require("persistence").load()',
                        desc = " Restore Session",
                        icon = " ",
                        key = "s",
                    },
                    {
                        action = 'lua require("telescope.builtin").find_files({ hidden = true})',
                        desc = " Find File",
                        icon = " ",
                        key = "f",
                    },
                    {
                        action = 'lua require("telescope.builtin").old_files()',
                        desc = " Recent Files",
                        icon = " ",
                        key = "r",
                    },
                    {
                        action = "Lazy update",
                        desc = "Update",
                        icon = "󰚰 ",
                        key = "l",
                    },
                    {
                        action = "Leet",
                        desc = "Leet code",
                        icon = " ",
                        key = "n",
                    },
                    {
                        action = "qa",
                        desc = " Quit",
                        icon = "",
                        key = "q",
                    },
                },
            },
        })
    end,
}
