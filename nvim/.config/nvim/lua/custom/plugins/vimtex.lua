return {
    "lervag/vimtex",
    lazy = false,
    config = function()
        -- vim.g.vimtex_view_method = "zathura"
        vim.g.vimtex_quickfix_open_on_warning = 0
        vim.g.vimtex_view_general_viewer = "qpdfview --unique"
    end,
}
