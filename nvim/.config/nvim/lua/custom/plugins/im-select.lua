local is_mac = vim.fn.has("mac") == 1

return {
    "keaising/im-select.nvim",
    opts = {
        -- macOS switches input methods through macism; elsewhere it goes
        -- through fcitx5, which is in the desktop package group.
        default_im_select = is_mac and "com.apple.keylayout.ABC" or "keyboard-us",
        default_command = is_mac and "macism" or "fcitx5-remote",
    },
}
