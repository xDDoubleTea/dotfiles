-- Neovim configuration used only inside VS Code (vscode-neovim).
--
-- VS Code owns LSP, completion, syntax highlighting, the file tree, git and the
-- statusline, so none of the plugins from the terminal config are loaded here:
-- they would duplicate that work and slow every window down. Neovim is kept for
-- what it is better at, which is editing: motions, text objects, registers,
-- macros and marks.
--
-- Point VS Code at this file with the setting below. It takes an absolute path,
-- so substitute your own home directory:
--   "vscode-neovim.neovimInitVimPaths.linux": "<home>/.config/nvim/vscode.lua"

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Editing options from the terminal config still matter, because Neovim handles
-- searching and motions here. Plugins, autocmds and mappings are skipped.
pcall(require, "options")

-- The `vscode` module is injected by the extension and only exists inside VS
-- Code, so loading this file anywhere else stops here instead of erroring.
local ok, vscode = pcall(require, "vscode")
if not ok then
    return
end

local map = vim.keymap.set

--- Run a VS Code command as if it were a Neovim mapping.
local function action(name)
    return function()
        vscode.action(name)
    end
end

-- ─── Files and search ────────────────────────────────────────────────────
map("n", "<leader>ff", action("workbench.action.quickOpen"), { desc = "[F]ind [F]ile" })
map("n", "<leader>fg", action("workbench.action.findInFiles"), { desc = "[F]ind by [G]rep" })
map("n", "<leader>p", action("workbench.action.showCommands"), { desc = "Command [P]alette" })
map("n", "<leader>e", action("workbench.view.explorer"), { desc = "Toggle [E]xplorer" })
map("n", "<leader>b", action("workbench.action.toggleSidebarVisibility"), { desc = "Toggle side[B]ar" })

-- ─── Language features (VS Code's LSP, not Neovim's) ─────────────────────
map("n", "gd", action("editor.action.revealDefinition"), { desc = "[G]oto [D]efinition" })
map("n", "gr", action("editor.action.goToReferences"), { desc = "[G]oto [R]eferences" })
map("n", "gi", action("editor.action.goToImplementation"), { desc = "[G]oto [I]mplementation" })
map("n", "K", action("editor.action.showHover"), { desc = "Show hover" })
map("n", "<leader>rn", action("editor.action.rename"), { desc = "[R]e[n]ame symbol" })
map({ "n", "v" }, "<leader>ca", action("editor.action.quickFix"), { desc = "[C]ode [A]ction" })
map("n", "<leader>fm", action("editor.action.formatDocument"), { desc = "[F]or[m]at document" })

-- ─── Diagnostics ─────────────────────────────────────────────────────────
map("n", "]d", action("editor.action.marker.next"), { desc = "Next [D]iagnostic" })
map("n", "[d", action("editor.action.marker.prev"), { desc = "Previous [D]iagnostic" })
map("n", "<leader>d", action("workbench.actions.view.problems"), { desc = "[D]iagnostics panel" })

-- ─── Tests ───────────────────────────────────────────────────────────────
map("n", "<leader>tt", action("testing.runAtCursor"), { desc = "Run [T]est at cursor" })
map("n", "<leader>ta", action("testing.runAll"), { desc = "Run [T]est [A]ll" })
map("n", "<leader>tf", action("testing.runCurrentFile"), { desc = "Run [T]ests in [F]ile" })

-- ─── Folding (VS Code's folds, not Neovim's) ─────────────────────────────
map("n", "zc", action("editor.fold"))
map("n", "zo", action("editor.unfold"))
map("n", "zR", action("editor.unfoldAll"))
map("n", "zM", action("editor.foldAll"))

-- ─── Window splits ───────────────────────────────────────────────────────
-- vscode-neovim already translates <C-w> commands to VS Code editor groups.
map("n", "<leader>wh", "<C-w>h", { desc = "Switch [W]indow left" })
map("n", "<leader>wj", "<C-w>j", { desc = "Switch [W]indow down" })
map("n", "<leader>wk", "<C-w>k", { desc = "Switch [W]indow up" })
map("n", "<leader>wl", "<C-w>l", { desc = "Switch [W]indow right" })

-- ─── Terminal ────────────────────────────────────────────────────────────
map("n", "tt", action("workbench.action.terminal.toggleTerminal"), { desc = "[T]oggle [T]erminal" })

-- Comments keep working through vscode-neovim's built-in gc / gcc bindings.
map("n", "mm", "gcc", { desc = "Toggle comment", remap = true })
map("v", "mm", "gc", { desc = "Toggle comment selection", remap = true })
