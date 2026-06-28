return {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
                local jdtls = require("jdtls")
                local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
                local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name

                -- Requires jdtls to be installed via Mason
                local mason_registry = require("mason-registry")
                local jdtls_pkg = mason_registry.get_package("jdtls")
                local jdtls_path = jdtls_pkg:get_install_path()

                local config = {
                    cmd = {
                        "java",
                        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                        "-Dosgi.bundles.defaultStartLevel=4",
                        "-Declipse.product=org.eclipse.jdt.ls.core.product",
                        "-Dlog.protocol=true",
                        "-Dlog.level=ALL",
                        "-Xmx1g",
                        "--add-modules=ALL-SYSTEM",
                        "--add-opens",
                        "java.base/java.util=ALL-UNNAMED",
                        "--add-opens",
                        "java.base/java.lang=ALL-UNNAMED",
                        "-jar",
                        vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
                        "-configuration",
                        jdtls_path .. "/config_linux",
                        "-data",
                        workspace_dir,
                    },
                    root_dir = require("jdtls.setup").find_root({
                        ".git",
                        "mvnw",
                        "gradlew",
                        "pom.xml",
                        "build.gradle",
                    }),
                    settings = {
                        java = {
                            signatureHelp = { enabled = true },
                            contentProvider = { preferred = "fernflower" },
                        },
                    },
                }
                jdtls.start_or_attach(config)
            end,
        })
    end,
}
