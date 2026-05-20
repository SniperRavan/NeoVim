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
			-- NOTE: dotfiles visibility is NOT configured here.
			-- The explorer is a picker in disguise — hidden files are
			-- controlled under picker.sources.explorer below.
			explorer = {
				enabled = true,
				-- replace_netrw = true, -- REMOVED: was auto-opening explorer on startup, fighting Alpha dashboard

				win = {
					list = {
						keys = {
							["."] = "toggle_hidden", -- Press . to toggle dotfiles while inside tree
						},
					},
				},
			},

			-- ── Picker (fuzzy finder + explorer source) ────────────
			-- FIX: dotfiles in the explorer sidebar are controlled HERE,
			-- not under explorer.filter. Snacks explorer is a picker source
			-- and reads hidden/ignored from picker.sources.explorer.
			-- Without hidden = true here, .env / .gitignore won't appear
			-- in the sidebar even if explorer.filter.dotfiles = false.
			picker = {
				enabled = true,
				sources = {
					explorer = {
						auto_close = false, -- Keep explorer open when picker closes
						hidden = true, -- Show dotfiles (.env, .gitignore, etc.) in sidebar
						ignored = true, -- Show git-ignored files in sidebar
					},
					files = {
						hidden = true, -- Also show dotfiles in <leader>ff
						ignored = true,
					},
					grep = {
						hidden = true, -- Also search inside dotfiles with <leader>fg
						ignored = true,
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
		event = "VeryLazy",
		opts = {
			-- Group labels — shown when you press <leader> and wait.
			-- Without these, which-key shows the first single-key match
			-- instead of waiting for the full sequence (e.g. "l" shows
			-- "Focus Window Right" instead of the "l" group for Live Server).
			spec = {
				{ "<leader>f", group = "Find" },
				{ "<leader>l", group = "Live Server" },
				{ "<leader>c", group = "Copilot" },
				{ "<leader>d", group = "Diagnostics" },
				{ "<leader>r", group = "Rename" },
				{ "<leader>g", group = "Global Search" },
				{ "<leader>m", group = "Markdown" },
				{ "<leader>w", group = "Window" },
			},
		},
	},
}
