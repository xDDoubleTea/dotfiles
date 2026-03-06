return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_c, 1, {
        function()
          return "" .. vim.fn.system("uname -r"):gsub("\n", "")
        end,
        icon = "",
      })
    end,
  },
}
