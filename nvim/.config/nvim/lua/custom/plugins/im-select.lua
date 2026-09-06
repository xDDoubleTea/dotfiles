local is_mac = vim.fn.has("mac") == 1

-- macOS switches input methods through macism; elsewhere it goes through
-- fcitx5, which is in the desktop package group.
local command = is_mac and "macism" or "fcitx5-remote"

return {
    "keaising/im-select.nvim",
    -- Headless boxes have no input-method daemon -- over SSH there is no
    -- fcitx5 -- and the plugin errors on every mode change without one.
    cond = function()
        return vim.fn.executable(command) == 1
    end,
    opts = {
        default_im_select = is_mac and "com.apple.keylayout.ABC" or "keyboard-us",
        default_command = command,
    },
}
