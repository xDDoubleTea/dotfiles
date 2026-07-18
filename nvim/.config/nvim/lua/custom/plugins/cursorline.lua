return {
    "ya2s/nvim-cursorline",
    config = function()
        require("nvim-cursorline").setup({
            disable_filetypes = {},
            disable_buftypes = {},
            cursorline = {
                enable = true,
                timeout = 2500,
                number = false,
            },
            cursorword = {
                enable = true,
                min_length = 3,
                hl = { underline = true },
            },
        })
    end,
}
