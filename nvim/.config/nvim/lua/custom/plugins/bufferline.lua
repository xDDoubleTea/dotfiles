return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    keys = {
        { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
        { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
        { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
        { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
        { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
        { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
        { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
        { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
        { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
        { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
        { "<leader>bj", "<cmd>BufferLinePick<cr>", desc = "Pick Buffer" },
    },
    opts = {
        options = {
            always_show_bufferline = true,
            diagnostics = "nvim_lsp",
            color_icons = true,
            separator_style = "thick",
            show_close_icon = true,
            show_tab_indicators = true,
            show_buffer_close_icons = true,
            show_buffer_icons = true,
        },
    },
    config = function(_, opts)
        require("bufferline").setup(opts)
    end,
}
