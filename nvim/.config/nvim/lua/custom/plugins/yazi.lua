return {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
        {
            "<leader>e",
            "<cmd>Yazi<cr>",
            desc = "Open yazi at current file",
        },
        {
            "<leader>E",
            "<cmd>Yazi cwd<cr>",
            desc = "Open yazi in working directory",
        },
        {
            "<leader>cw",
            "<cmd>Yazi toggle<cr>",
            desc = "Resume the last yazi session",
        },
    },
    opts = {
        -- If set to true, opening a directory in Neovim (e.g., `nvim .`) opens Yazi instead of netrw
        open_for_directories = true,

        -- Floating window configuration
        floating_window_scaling_factor = 0.9,
        yazi_floating_window_winblend = 0,

        -- Neovim-specific keymaps inside the Yazi floating window
        keymaps = {
            show_help = "<f1>",
        },
    },
}
