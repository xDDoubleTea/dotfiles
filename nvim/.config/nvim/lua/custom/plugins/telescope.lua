local builtin = require("telescope.builtin")
return {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
        "nvim-lua/plenary.nvim",
        -- optional but recommended
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
        {
            "<leader>ff",
            function()
                builtin.find_files({ hidden = true })
            end,
            desc = "Telescope Files Hidden",
        },
        {
            "<leader>fg",
            function()
                builtin.live_grep({ additional_args = { "-u" } })
            end,
            desc = "Telescope Grep Hidden",
        },
        {
            "<leader>fb",
            function()
                builtin.buffers()
            end,
            desc = "Telescope find buffers",
        },
        { "<leader>ss", builtin.lsp_document_symbols, desc = "Telescope search symbols" },
        { "<leader>sS", builtin.lsp_workspace_symbols, desc = "Telescope search workspace Symbols" },
        {
            "<leader>sb",
            function()
                builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in open files" })
            end,
            desc = "Telescope grep buffers",
        },
        {
            "<leader>sg",
            function()
                builtin.live_grep({ cwd = vim.fn.getcwd() })
            end,
            desc = "Grep cwd",
        },
        {
            "<leader>sG",
            function()
                local root = vim.fs.root(0, { ".git", "Makefile", "compile_commands.json", "package.json" })

                root = root or vim.fn.getcwd()

                builtin.live_grep({
                    cwd = root,
                    prompt_title = "Live Grep (" .. root .. ")",
                })
            end,
            desc = "Grep cwd",
        },
    },
    config = function()
        require("telescope").setup({
            pickers = {
                find_files = {
                    hidden = true,
                    find_command = {
                        "rg",
                        "--files",
                        "--hidden",
                        "--ignore",
                    },
                },
            },
        })
    end,
}
