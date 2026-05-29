return {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("dashboard").setup({
            theme = "hyper",
            config = {
                weak_header = { enable = true },
                header = {
                    "",
                    " ███╗   ██║███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
                    " ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
                    " ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
                    " ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
                    " ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
                    " ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
                    "",
                },
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
