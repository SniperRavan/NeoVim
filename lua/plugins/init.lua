local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	--------------------------------------------------
	-- 🔑 WHICH-KEY
	--------------------------------------------------
	{ "folke/which-key.nvim", event = "VeryLazy", opts = {} },

	--------------------------------------------------
	-- 🍿 SNACKS.NVIM (The God Plugin)
	--------------------------------------------------
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			explorer = {
				enabled = true,
				replace_netrw = true,

				win = {
					list = {
						keys = {
							["."] = "toggle_hidden",
						},
					},
				},

				filter = {
					dotfiles = false,
					git_ignored = false,
				},
			},

			picker = {
				enabled = true,
				sources = {
					explorer = {
						auto_close = false,
					},
				},
			},

			notifier = {
				enabled = true,
				timeout = 3000,
				width = { min = 30, max = 80 },
				height = { min = 1, max = 10 },
				margin = { top = 1, right = 1 },
				padding = true,
				sort = { "level", "added" },

				style = "fancy",

				top_down = false,
			},
			zen = {
				enabled = true,
			},
		},

		config = function(_, opts)
			require("snacks").setup(opts)

			-- Global notifications
			vim.notify = require("snacks").notifier.notify
		end,
	},

	--------------------------------------------------
	-- 🎨 THEME (RUTHLESS LINUX TRANSPARENCY)
	--------------------------------------------------
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				transparent_background = true,
				integrations = {
					which_key = true,
					blink_cmp = true,
					gitsigns = true,
					markdown = true,
				},
				custom_highlights = function(colors)
					return {
						Normal = { bg = "NONE" },
						NormalFloat = { bg = "NONE" },
						FloatBorder = { bg = "NONE", fg = colors.mauve },
						TabLineFill = { bg = "NONE" },
						TabLine = { bg = "NONE" },
						SnacksNormal = { bg = "NONE" },
						SnacksNormalNC = { bg = "NONE" },
						SnacksBackdrop = { bg = "NONE" },
						SnacksWinBar = { bg = "NONE" },
					}
				end,
			})
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},

	--------------------------------------------------
	-- 📝 WEB DEV TOOLS & FILE MANAGEMENT
	--------------------------------------------------
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_auto_close = 1
		end,
		ft = { "markdown" },
	},
	{ "barrett-ruth/live-server.nvim", cmd = { "LiveServerStart", "LiveServerStop" } },
	{
		"stevearc/oil.nvim",
		opts = {
			default_file_explorer = false,

			view_options = {
				show_hidden = true,
			},
		},
	},

	--------------------------------------------------
	-- 🌳 TREESITTER
	--------------------------------------------------
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local ok, configs = pcall(require, "nvim-treesitter.configs")
			if not ok then
				return
			end

			configs.setup({
				ensure_installed = { "lua", "javascript", "html", "css", "typescript", "vim", "vimdoc", "markdown" },
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	--------------------------------------------------
	-- 🤖 AI: COPILOT & CHAT
	--------------------------------------------------
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = true, auto_trigger = true, keymap = { accept = "<C-l>" } },
				panel = { enabled = false },
			})
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = { "zbirenbaum/copilot.lua", "nvim-lua/plenary.nvim" },
		build = "make tiktoken",
		opts = {
			window = { layout = "float", width = 0.8, height = 0.8 },
		},
	},

	--------------------------------------------------
	-- 📊 STATUSLINE, BUFFERLINE & UI
	--------------------------------------------------
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = { theme = "auto", section_separators = "", component_separators = "" },
			})
		end,
	},
	{
		"akinsho/bufferline.nvim",
		dependencies = "echasnovski/mini.icons",
		config = function()
			require("bufferline").setup({ options = { show_buffer_close_icons = true, show_close_icon = true } })
		end,
	},
	{
		"akinsho/toggleterm.nvim",

		config = function()
			require("toggleterm").setup({
				direction = "float",
				shell = vim.o.shell,

				float_opts = {
					border = "rounded",
					winblend = 0,
				},
			})

			vim.api.nvim_set_hl(0, "FloatBorder", {
				fg = "#cba6f7",
				bg = "NONE",
			})
		end,
	},

	--------------------------------------------------
	-- ✨ ANIMATIONS, TEXT OBJECTS & MULTI-CURSOR
	--------------------------------------------------
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup()
		end,
	},
	{
		"gen740/SmoothCursor.nvim",
		config = function()
			require("smoothcursor").setup({ type = "default", fancy = { enable = true } })
		end,
	},
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			require("mini.ai").setup()
			require("mini.surround").setup()
			require("mini.icons").setup()
		end,
	},
	{
		"mg979/vim-visual-multi",
		branch = "master",
		init = function()
			vim.g.VM_theme = "ocean"
			vim.g.VM_maps = { ["Find Under"] = "<C-n>" }
		end,
	},

	--------------------------------------------------
	-- 🏠 DASHBOARD
	--------------------------------------------------
	{
		"goolord/alpha-nvim",

		lazy = false,
		priority = 900,

		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

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

			dashboard.section.buttons.val = {
				dashboard.button("f f", "󰈔  Find File", function()
					Snacks.picker.files()
				end),

				dashboard.button("f n", "  New File", ":ene <BAR> startinsert <CR>"),

				dashboard.button("f r", "  Recent Files", function()
					Snacks.picker.recent()
				end),

				dashboard.button("f g", "󰈭  Find Text", function()
					Snacks.picker.grep()
				end),

				dashboard.button("f c", "  Configuration", ":e $MYVIMRC<CR>"),

				dashboard.button("q", "󰩈  Quit", ":qa<CR>"),
			}

			local v = vim.version()
			dashboard.section.footer.val = "⚡ Neovim v" .. v.major .. "." .. v.minor .. "." .. v.patch

			alpha.setup(dashboard.opts)

			-- Disable alpha auto redraws (fixes Invalid window/buffer errors)
			--			vim.cmd([[
			--       autocmd! AlphaRedraw
			--     ]])
			-- Show dashboard on startup
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					vim.schedule(function()
						Snacks.explorer.open({
							layout = {
								preset = "sidebar",
								position = "left",
								width = 30,
							},
						})

						vim.cmd("Alpha")
					end)
				end,
			})
			vim.api.nvim_create_autocmd("BufEnter", {
				nested = true,
				callback = function()
					local bufs = vim.tbl_filter(function(buf)
						return vim.bo[buf.bufnr].buflisted
							and vim.api.nvim_buf_is_valid(buf.bufnr)
							and vim.bo[buf.bufnr].buftype == ""
					end, vim.fn.getbufinfo())

					if #bufs == 0 then
						vim.cmd("Alpha")
					end
				end,
			})
		end,
	},

	--------------------------------------------------
	-- 🌿 GIT & DIAGNOSTICS
	--------------------------------------------------
	{ "lewis6991/gitsigns.nvim", config = true },
	{
		"f-person/git-blame.nvim",
		config = function()
			vim.g.gitblame_enabled = 1
		end,
	},
	{ "rachartier/tiny-inline-diagnostic.nvim", config = true },

	--------------------------------------------------
	-- 🧠 LSP, AUTOFORMAT & BLINK.CMP (THE SPEED DEMON)
	--------------------------------------------------
	{ "williamboman/mason.nvim", config = true },
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({ ensure_installed = { "lua_ls", "ts_ls", "html", "cssls" } })
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },

		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				},
				ts_ls = {},
				html = {},
				cssls = {},
			}

			for server, config in pairs(servers) do
				config.capabilities = capabilities

				vim.lsp.config(server, config)
				vim.lsp.enable(server)
			end
		end,
	},
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					javascript = { "prettier" },
					typescript = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
					json = { "prettier" },
					lua = { "stylua" },
				},
				format_on_save = { timeout_ms = 500, lsp_fallback = true },
			})
		end,
	},
	{
		"saghen/blink.cmp",
		version = "*",
		opts = {
			keymap = {
				preset = "default",

				["<Tab>"] = { "select_next", "fallback" },
				["<S-Tab>"] = { "select_prev", "fallback" },

				["<CR>"] = { "accept", "fallback" },
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				menu = {
					auto_show = true,
				},
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			signature = { enabled = true },
		},
	},
})

-- LSP Keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = { buffer = ev.buf }

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	end,
})

vim.opt.laststatus = 3
vim.opt.termguicolors = true
vim.opt.cmdheight = 0
vim.opt.showmode = false
vim.opt.fillchars = {
	eob = " ",
}
