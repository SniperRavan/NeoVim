-- ============================================================
--  plugins/lsp.lua
--  Language Server Protocol stack:
--  Mason (installer) → mason-lspconfig (bridge) → nvim-lspconfig (config)
--  Conform (formatter) + Blink.cmp (completion engine)
--
--  What is an LSP?
--  A Language Server Protocol server is a program that understands
--  your code. It runs in the background and provides:
--    • Autocomplete suggestions
--    • Go-to-definition (gd)
--    • Hover documentation (K)
--    • Rename symbol across files (<leader>rn)
--    • Code actions: quick fixes (<leader>ca)
--    • Error/warning diagnostics (the red/yellow underlines)
-- ============================================================

return {

	-- ── Mason: the LSP/formatter installer ─────────────────────
	-- :Mason opens a UI where you can install/uninstall servers.
	-- Think of it as apt/npm but specifically for coding tools.
	{
		"williamboman/mason.nvim",
		config = true, -- calls require("mason").setup() with defaults
	},

	-- ── mason-lspconfig: bridge between Mason and lspconfig ────
	-- ensure_installed = these servers are auto-installed when missing.
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls", -- Lua (for editing Neovim config itself)
					"ts_ls", -- TypeScript & JavaScript
					"html", -- HTML
					"cssls", -- CSS
				},
			})
		end,
	},

	-- ── nvim-lspconfig: configure language servers + LSP keymaps ─
	--
	-- This plugin is the core bridge between Neovim and language
	-- servers installed through Mason.
	--
	-- Responsibilities:
	--   • Start/configure language servers
	--   • Extend completion capabilities through blink.cmp
	--   • Register LSP keymaps when a server attaches
	--   • Provide hover/docs/rename/goto-definition/etc.
	--
	-- IMPORTANT:
	-- We keep BOTH:
	--   1. server setup
	--   2. LspAttach keymaps
	--
	-- inside ONE plugin spec.
	--
	-- Why?
	-- Because splitting the same plugin into multiple specs can:
	--   • duplicate config execution
	--   • duplicate autocmds
	--   • create load-order confusion
	--   • make debugging harder later
	--
	-- A single spec is cleaner and more predictable.
	{
		"neovim/nvim-lspconfig",

		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"saghen/blink.cmp",
		},

		config = function()
			-- ── blink.cmp capabilities ────────────────────────────
			-- Extend LSP completion capabilities so language servers
			-- know we support advanced completion features.
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- ── Language server configurations ───────────────────
			-- Each key is the server name.
			-- The value is its configuration table.
			local servers = {

				-- Lua Language Server
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								-- Prevent "undefined global" warnings for these globals
								-- vim   → Neovim API
								-- Snacks → snacks.nvim (used in keymaps, autocmds)
								globals = { "vim", "Snacks" },
							},
						},
					},
				},

				-- TypeScript / JavaScript
				ts_ls = {},

				-- HTML
				html = {},

				-- CSS
				cssls = {},
			}

			-- ── Enable all configured servers ────────────────────
			for server, cfg in pairs(servers) do
				cfg.capabilities = capabilities

				vim.lsp.config(server, cfg)
				vim.lsp.enable(server)
			end

			-- ── LSP keymaps ──────────────────────────────────────
			--
			-- These keymaps only become active when an LSP server
			-- attaches to the current buffer.
			--
			-- This avoids polluting non-LSP buffers with LSP-only keys.
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
				callback = function(ev)
					local opts = { buffer = ev.buf }

					-- gd → go to definition
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

					-- K → hover documentation
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

					-- gr → list references
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

					-- <leader>rn → rename symbol project-wide
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

					-- <leader>ca → code actions / quick fixes
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				end,
			})
		end,
	},

	-- ── Conform: auto-formatter ────────────────────────────────
	-- Runs the right formatter when you save a file.
	-- Requires formatters to be installed via Mason:
	--   :MasonInstall prettier stylua
	{
		"stevearc/conform.nvim",
		event = "BufWritePre", -- Load just before saving
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
				-- Automatically format on every :w / :write
				format_on_save = {
					timeout_ms = 500,
					-- lsp_fallback = true, -- deprecated in conform >= 7.x, use lsp_format below
					lsp_format = "fallback", -- if no formatter configured, try LSP formatting
				},
			})
		end,
	},

	-- ── Blink.cmp: the completion engine ───────────────────────
	-- Shows a popup menu as you type with suggestions from:
	--   lsp      → the language server (functions, variables, types)
	--   path     → file paths (when you type ./ or /)
	--   snippets → code snippets
	--   buffer   → words already in the current file
	{
		"saghen/blink.cmp",
		version = "*",
		opts = {
			keymap = {
				preset = "default",
				["<Tab>"] = { "select_next", "fallback" }, -- Tab → next suggestion
				["<S-Tab>"] = { "select_prev", "fallback" }, -- Shift+Tab → previous
				["<CR>"] = { "accept", "fallback" }, -- Enter → accept suggestion
			},

			appearance = {
				nerd_font_variant = "mono", -- Use the mono version of Nerd Font icons
			},

			completion = {
				menu = { auto_show = true }, -- Show menu automatically (don't wait for trigger)
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			signature = { enabled = true }, -- Show function signature as you type arguments
		},
	},

	-- ── Tiny-inline-diagnostic: prettier inline errors ─────────
	-- Shows errors/warnings as virtual text at the end of the line
	-- instead of in the gutter only.
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "LspAttach",
		config = true,
	},
}
