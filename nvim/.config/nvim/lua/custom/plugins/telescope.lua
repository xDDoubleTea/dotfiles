return {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
        "nvim-lua/plenary.nvim",
        -- optional but recommended
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
        {
            "<leader>ff",
            function()
                require("telescope.builtin").find_files({ hidden = true })
            end,
            desc = "Telescope Files Hidden",
        },
        {
            "<leader>fg",
            function()
                require("telescope.builtin").live_grep({ additional_args = { "-u" } })
            end,
            desc = "Telescope Grep Hidden",
        },
        {
            "<leader>fb",
            function()
                require("telescope.builtin").buffers()
            end,
            desc = "Telescope find buffers",
        },
    },
    config = function()
        require("telescope").setup({
            pickers = {
                find_files = {
                    hidden = true,
                    find_command = {
                        "rg",
                        "--files",
                        "--hidden",
                        "--ignore",
                    },
                },
            },
        })
    end,
}
