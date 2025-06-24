-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
map("n", "<C-b>", "<C-b>zz", { desc = "Scroll up one page and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up half page and center" })
map("n", "<C-f>", "<C-f>zz", { desc = "Scroll down one page and center" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half page and center" })
