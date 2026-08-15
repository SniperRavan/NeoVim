-- ============================================================
--  plugins/ui.lua
--  All purely visual / UI plugins:
--  Alpha (dashboard), Bufferline (tabs), Lualine (statusline),
--  ToggleTerm (floating terminal), Oil (filesystem editor),
--  Markdown Preview, Live Server, Catppuccin theme
-- ============================================================

return {

	-- ── Catppuccin: the colorscheme ────────────────────────────
	-- "mocha" is the darkest flavor. transparent_background = true
	-- lets your terminal's background color show through.
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000, -- Load the theme before any other plugin
		lazy = false,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true, -- ← makes the glass/cyberpunk look work

				integrations = {
					bufferline = true,
					gitsigns = true,
					treesitter = true,
					which_key = true,
					blink_cmp = true,
					mini = { enabled = true },
					snacks = true,
				},
			})
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},

	-- ── Alpha: startup dashboard ────────────────────────────────
	-- Shows a custom ASCII header + buttons when Neovim opens.
	-- Buttons call Snacks pickers instead of Telescope.
	{
		"goolord/alpha-nvim",
		lazy = false,
		priority = 900,

		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- ── ASCII Header ──────────────────────────────────────
			-- TIP: If this looks broken, your terminal font does NOT
			-- support box-drawing characters. Install a Nerd Font and
			-- set it in Alacritty's config: font.normal.family.
			-- Recommended: JetBrainsMono Nerd Font
			dashboard.section.header.val = {
				[[                                                                       ]],
				[[       ████ ██████           █████      ██                     ]],
				[[      ███████████             █████                             ]],
				[[      █████████ ███████████████████ ███   ███████████   ]],
				[[     █████████  ███    █████████████ █████ ██████████████   ]],
				[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
				[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
				[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
			}

			-- ── Dashboard buttons ────────────────────────────────
			-- Each button: display text, shortcut shown, what it does
			dashboard.section.buttons.val = {
				dashboard.button("f f", "󰈔  Find File", ":lua Snacks.picker.files()<CR>"),
				dashboard.button("f n", "  New File", ":ene <BAR> startinsert <CR>"),
				dashboard.button("f r", "  Recent Files", ":lua Snacks.picker.recent()<CR>"),
				dashboard.button("f g", "󰈭  Find Text", ":lua Snacks.picker.grep()<CR>"),
				dashboard.button("f c", "  Configuration", ":e $MYVIMRC<CR>"),
				dashboard.button("q", "󰩈  Quit", ":qa<CR>"),
			}

			local tagline = {
				type = "text",
				val = "Your ideas, in code.",
				opts = { position = "center", hl = "Comment" },
			}

			local v = vim.version()
			local version_str = "Neovim v" .. v.major .. "." .. v.minor .. "." .. v.patch
			local version_footer = {
				type = "text",
				val = "🟢 No sessions                      " .. version_str .. "  ",
				opts = { position = "center", hl = "Comment" },
			}

			dashboard.config.layout = {
				{ type = "padding", val = 2 },
				dashboard.section.header,
				{ type = "padding", val = 2 },
				dashboard.section.buttons,
				{ type = "padding", val = 2 },
				tagline,
				{ type = "padding", val = 1 },
				version_footer,
			}

			alpha.setup(dashboard.opts)
		end,
	},

	-- ── Bufferline: tabs at the top of the screen ──────────────
	-- Each open file appears as a tab. Shift+L / Shift+H to cycle.
	{
		"akinsho/bufferline.nvim",
		dependencies = "echasnovski/mini.icons",
		event = "VeryLazy",
		config = function()
			require("bufferline").setup({
				options = {
					show_buffer_close_icons = true,
					show_close_icon = true,
					-- Don't show Alpha or explorer in the tab bar
					custom_filter = function(buf)
						local ft = vim.bo[buf].filetype
						-- Filter out alpha and any snacks explorer variant
						return ft ~= "alpha" and not (ft:find("snacks") and ft:find("explorer"))
					end,
				},
			})
		end,
	},

	-- ── Lualine: statusline at the bottom ──────────────────────
	-- Shows: mode, branch, filename, diagnostics, progress, position.
	--
	-- FIX: ":LualineNotices" warning was caused by deprecated options.
	-- Removed: section_separators = "" and component_separators = "".
	-- These are valid but must be set inside options{} as tables, not strings.
	-- Empty string is ambiguous — use explicit empty table {} instead.
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			require("lualine").setup({
				options = {
					theme = "catppuccin-mocha", -- FIX: was "catppuccin" — lualine needs the full flavor name

					-- FIX: use tables not strings for separators
					-- Empty tables = no separator character (flat look)
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },

					globalstatus = true, -- Single statusline (matches opt.laststatus=3)
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { { "filename", path = 1 } }, -- path=1 shows relative path
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},

	-- ── ToggleTerm: floating terminal ──────────────────────────
	-- <leader>t → opens a floating terminal window.
	-- Inside the terminal, press Ctrl-\ Ctrl-n to enter NORMAL mode.
	-- Then press <leader>t again to close it.
	--
	-- FIX BUG: was `keys = { "<leader>t" }` which caused a race condition
	-- where the keymap fired before the plugin finished loading.
	-- Using event = "VeryLazy" guarantees it's loaded before any key fires.
	{
		"akinsho/toggleterm.nvim",
		--	keys = { "<leader>t" }, -- ← removed, caused race condition
		event = "VeryLazy",
		config = function()
			require("toggleterm").setup({
				direction = "float",
				shell = vim.o.shell, -- Uses your $SHELL (bash/zsh/fish/etc.)

				float_opts = {
					border = "rounded",
					winblend = 0, -- Terminal is fully opaque (readable)
				},
			})

			-- Purple border around the floating terminal
			vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#cba6f7", bg = "NONE" })
		end,
	},

	-- ── Oil.nvim: edit filesystem like a buffer ─────────────────
	-- Press - to open the parent directory as a text buffer.
	-- Rename files by editing the text. Delete lines to delete files.
	-- Press Enter on a file to open it. Press - again to go up a level.
	--
	-- FIX BUG: was `keys = { "-" }` which intercepts the native Vim "-"
	-- motion during plugin load. Using cmd = { "Oil" } is safer —
	-- the keymap in keymaps.lua sends <cmd>Oil<CR> which triggers the cmd.
	{
		"stevearc/oil.nvim",
		--	keys = { "-" }, -- ← removed, was stealing native Vim motion
		cmd = { "Oil" },
		opts = {
			default_file_explorer = false, -- Let Snacks handle :edit .
			view_options = {
				show_hidden = true, -- Show dotfiles in Oil too
			},
		},
	},

	-- ── Markdown Preview ───────────────────────────────────────
	-- <leader>mp → opens your markdown file in the browser, live.
	-- Requires Node.js (it runs a small local server).
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_auto_close = 1 -- Close preview tab when you close the md buffer
		end,
		ft = { "markdown" },
	},

	-- ── Live Server ────────────────────────────────────────────
	-- <leader>ls → starts a live-reloading web server for HTML/CSS/JS.
	-- <leader>lx → stops it.
	-- Requires: npm i -g live-server
	--
	-- NOTE: live-server.nvim v0.2.0+ removed setup().
	-- Configuration is done via vim.g.live_server_* globals instead.
	{
		"barrett-ruth/live-server.nvim",
		cmd = { "LiveServerStart", "LiveServerStop" },
		init = function()
			-- Port to serve on
			vim.g.live_server_port = 5500

			-- Open browser automatically when server starts
			vim.g.live_server_open_browser = 1
		end,
	},
}
