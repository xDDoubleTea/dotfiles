-- Lean 4: language server, infoview (goals/hypotheses) and \-abbreviations
-- such as \e -> ε, \all -> ∀, \R -> ℝ. Loads only for .lean files.
-- Needs the toolchain from elan (`elan default stable`).
return {
  "Julian/lean.nvim",
  event = { "BufReadPre *.lean", "BufNewFile *.lean" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    mappings = true, -- <LocalLeader>i toggles the infoview
  },
}
