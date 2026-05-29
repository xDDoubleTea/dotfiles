return {
    "CRAG666/code_runner.nvim",
    cmd = { "RunCode", "RunFile", "RunProject" },
    keys = {
        { "<leader>rc", "<cmd>RunCode<CR>", desc = "Run Code" },
        { "<leader>rf", "<cmd>RunFile<CR>", desc = "Run File" },
    },
    opts = {
        mode = "float",
        float = {
            border = "rounded",
        },
        filetype = {
            java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
            python = "python3 -u",
            go = "go run",
            c = "cd $dir && clang $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
            cpp = "cd $dir && clang++ $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
        },
    },
}
