-- ============================================================
--  plugins/snacks.lua
--  folke/snacks.nvim — the "god plugin"
--  Handles: Explorer sidebar, Fuzzy Picker, Notifications, Zen mode
-- ============================================================

return {
	{
		"folke/snacks.nvim",
		priority = 1000, -- Load before everything else
		lazy = false, -- Must be eager (not lazy) so Snacks.* is available everywhere

		opts = {

			-- ── Explorer (sidebar file tree) ───────────────────────
			-- This replaces netrw (the built-in file browser).
			explorer = {
				enabled = true,
				replace_netrw = true, -- When you do :edit ., Snacks handles it

				win = {
					list = {
						keys = {
							["."] = "toggle_hidden", -- Press . inside the tree to show/hide dotfiles
						},
					},
				},

				filter = {
					dotfiles = true, -- Show dotfiles (.env, .gitignore, etc.) by default
					git_ignored = false, -- Show git-ignored files too
				},
			},

			-- ── Picker (fuzzy finder, replaces Telescope) ──────────
			picker = {
				enabled = true,
				sources = {
					explorer = {
						auto_close = false, -- Keep explorer open when picker closes
					},
				},
			},

			-- ── Notifier (fancy notification system) ───────────────
			-- Replaces vim.notify with beautiful floating notifications.
			notifier = {
				enabled = true,
				timeout = 3000, -- Notifications disappear after 3 seconds
				width = { min = 30, max = 80 },
				height = { min = 1, max = 10 },
				margin = { top = 1, right = 1 },
				padding = true,
				sort = { "level", "added" },
				style = "fancy", -- "fancy" | "compact" | "minimal"
				top_down = false, -- Newest notification appears at BOTTOM
			},

			-- ── Zen mode ──────────────────────────────────────────
			-- :lua Snacks.zen() → distraction-free writing mode
			zen = { enabled = true },
		},

		config = function(_, opts)
			require("snacks").setup(opts)

			-- Replace the global vim.notify so ALL plugins (LSP, Mason, etc.)
			-- show their notifications through Snacks instead of the tiny cmdline.
			vim.notify = require("snacks").notifier.notify
		end,
	},

	-- ── Which-key: shows available keymaps as you type ─────────
	-- Press <leader> and wait a moment — a popup shows what keys do what.
	{
		"folke/which-key.nvim",
		event = "VeryLazy", -- Load after startup (doesn't affect startup time)
		opts = {},
	},
}
