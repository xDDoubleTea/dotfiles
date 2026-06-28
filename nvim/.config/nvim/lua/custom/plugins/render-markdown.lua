return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "norg", "rmd", "org" },
    opts = {
        heading = {
            sign = false,
            icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        },
        code = {
            sign = false,
            width = "block",
            right_pad = 1,
        },
    },
}
