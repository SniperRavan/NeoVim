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

	-- ── nvim-lspconfig: configure each language server ─────────
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			-- blink.cmp extends the LSP capabilities so the server knows
			-- we support fancy completion features.
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Server configurations. Add extra servers here.
			-- Each key is the server name. The value is its config table.
			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								-- Tell lua_ls that "vim" is a valid global variable.
								-- Without this you'd get a warning on every vim.* call.
								globals = { "vim", "Snacks" },
							},
						},
					},
				},
				ts_ls = {}, -- TypeScript/JavaScript — no extra config needed
				html = {}, -- HTML
				cssls = {}, -- CSS
			}

			for server, config in pairs(servers) do
				config.capabilities = capabilities
				vim.lsp.config(server, config)
				vim.lsp.enable(server)
			end
		end,
	},

	-- ── LSP keymaps (set when an LSP attaches to a buffer) ─────
	-- These are defined here as an autocmd so they only activate
	-- when a language server is actually running for that file.
	{
		"neovim/nvim-lspconfig", -- same plugin, second spec just adds the autocmd
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
				callback = function(ev)
					local opts = { buffer = ev.buf }
					-- gd → jump to where a function/variable is defined
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					-- K  → show documentation for the thing under the cursor
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					-- <leader>rn → rename a symbol everywhere in the project
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					-- <leader>ca → show available quick-fix actions
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					-- gr → show all references to the thing under the cursor
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
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
					lsp_fallback = true, -- If no formatter configured, try LSP formatting
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
