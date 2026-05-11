-- ============================================================
--  plugins/editor.lua
--  Editing experience enhancements:
--  Treesitter, Mini.nvim suite, Neoscroll, SmoothCursor,
--  Visual-multi (multi-cursor)
-- ============================================================

return {

	-- ── Treesitter: proper syntax highlighting ─────────────────
	-- The built-in Neovim syntax highlighting uses regex patterns.
	-- Treesitter actually PARSES your code into a real syntax tree,
	-- giving you much more accurate highlighting, indentation, and
	-- the ability for other plugins to understand code structure.
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate", -- Update parsers after plugin updates
		event = { "BufReadPost", "BufNewFile" }, -- Load when you open any file

		config = function()
			local ok, configs = pcall(require, "nvim-treesitter.configs")
			if not ok then
				return
			end

			configs.setup({
				-- These parsers are automatically installed if missing.
				ensure_installed = {
					"lua",
					"javascript",
					"typescript",
					"html",
					"css",
					"json",
					"vim",
					"vimdoc",
					"markdown",
					"markdown_inline",
					"bash",
				},

				auto_install = true, -- Auto-install parsers for new filetypes you open
				highlight = { enable = true }, -- Turn on Treesitter highlighting
				indent = { enable = true }, -- Turn on Treesitter-based indentation
			})
		end,
	},

	-- ── Mini.nvim: a collection of small focused plugins ───────
	-- We use three modules from the mini.nvim family:
	{
		"echasnovski/mini.nvim",
		version = false,
		event = "VeryLazy",
		config = function()
			-- mini.ai: better text objects
			-- ciw = change inner word (built-in)
			-- cia = change inner "any" — adds function, class, etc. as targets
			-- Example: da) = delete everything inside parentheses including the ()
			require("mini.ai").setup()

			-- mini.surround: add/change/delete surrounding characters
			-- sa" = surround add " around selection
			-- sd" = surround delete "
			-- sr"' = surround replace " with '
			require("mini.surround").setup()

			-- mini.icons: file-type icons used by bufferline, explorer, etc.
			require("mini.icons").setup()
		end,
	},

	-- ── Neoscroll: smooth scrolling ────────────────────────────
	-- Makes Ctrl-d, Ctrl-u, Ctrl-f, Ctrl-b scroll smoothly
	-- instead of jumping instantly.
	{
		"karb94/neoscroll.nvim",
		event = "VeryLazy",
		config = function()
			require("neoscroll").setup()
		end,
	},

	-- ── SmoothCursor: animated cursor trail ────────────────────
	-- The cursor leaves a small animation trail as it moves,
	-- making it easier to track where you are in the file.
	{
		"gen740/SmoothCursor.nvim",
		event = "VeryLazy",
		config = function()
			require("smoothcursor").setup({
				type = "default",
				fancy = { enable = true },
			})
		end,
	},

	-- ── vim-visual-multi: multi-cursor editing ──────────────────
	-- Ctrl-n on a word → select it and find the next occurrence.
	-- Keep pressing Ctrl-n to add more cursors.
	-- Then type normally to edit all selections at once.
	{
		"mg979/vim-visual-multi",
		branch = "master",
		event = "VeryLazy",
		init = function()
			vim.g.VM_theme = "ocean"
			vim.g.VM_maps = {
				["Find Under"] = "<C-n>", -- Ctrl-n to start multi-cursor
			}
		end,
	},
}
