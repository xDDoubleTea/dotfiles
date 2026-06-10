return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        picker = { enabled = true },
        image = { enabled = false },
        explorer = { enabled = false },
        dashboard = { enabled = false },
        notifier = { enabled = false },
        statuscolumn = { enabled = false },
    },
    keys = {
        {
            "<leader>su",
            function()
                Snacks.picker.undo()
            end,
            desc = "Search Undo Tree",
        },
    },
}
