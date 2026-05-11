-- ============================================================
--  plugins/git.lua
--  Git integration:
--    Gitsigns  → shows changed/added/removed lines in the gutter
--    Git-blame → shows who wrote each line and when
-- ============================================================

return {

	-- ── Gitsigns: git change indicators in the sign column ─────
	-- The sign column is the narrow strip on the left (where LSP
	-- error icons appear). Gitsigns adds:
	--   │ (bar)      → line was modified
	--   + (plus)     → line was added
	--   - (underscore) → line above was deleted
	--
	-- These appear automatically when you're inside a git repo.
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = true, -- calls require("gitsigns").setup() with defaults
	},

	-- ── Git-blame: inline commit info for each line ─────────────
	-- Shows "You • 2 hours ago • commit message" at the end of
	-- each line you hover over or in a virtual text overlay.
	-- Toggle with :GitBlameToggle
	{
		"f-person/git-blame.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			-- Start with blame visible. Set to 0 to hide by default.
			vim.g.gitblame_enabled = 1
		end,
	},
}
