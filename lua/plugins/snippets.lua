-- ============================================================
--  plugins/snippets.lua
--  Snippet engine + snippet collection
--
--  LuaSnip    → the snippet engine (expand + jump through fields)
--  friendly-snippets → a big collection of snippets for every
--                      language: HTML, CSS, JS, TS, Lua, etc.
--
--  These integrate with blink.cmp automatically — snippets
--  appear in the completion menu alongside LSP suggestions.
--
--  HOW TO USE:
--    Type a trigger word and press Tab to expand.
--    Press Tab again to jump to the next field.
--    Press Shift-Tab to jump back.
--
--  COMMON HTML TRIGGERS:
--    !        → full HTML5 boilerplate
--    html5    → HTML5 boilerplate
--    link     → <link> tag
--    script   → <script> tag
--    inp      → <input> tag
--    btn      → <button> tag
--    div      → <div></div>
--    form     → <form> block
--
--  COMMON JS/TS TRIGGERS:
--    cl       → console.log()
--    fn       → function declaration
--    afn      → arrow function
--    imp      → import statement
--    timeout  → setTimeout()
--    prom     → new Promise()
--    trycatch → try/catch block
--    fe       → forEach loop
--
--  COMMON CSS TRIGGERS:
--    bgc      → background-color
--    flex     → display: flex block
--    grid     → display: grid block
--    media    → @media query
-- ============================================================

return {

	-- ── LuaSnip: the snippet engine ────────────────────────────
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp", -- optional: enables regexp in snippets
		dependencies = { "rafamadriz/friendly-snippets" },

		config = function()
			local luasnip = require("luasnip")

			-- Load the friendly-snippets collection.
			-- This gives you snippets for HTML, CSS, JS, TS, Lua, Python, etc.
			require("luasnip.loaders.from_vscode").lazy_load()

			-- Tab → expand snippet or jump to next field
			vim.keymap.set({ "i", "s" }, "<Tab>", function()
				if luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					-- Fall through to normal Tab behaviour
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
				end
			end, { desc = "Snippet expand / jump next" })

			-- Shift-Tab → jump to previous snippet field
			vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
				if luasnip.jumpable(-1) then
					luasnip.jump(-1)
				end
			end, { desc = "Snippet jump previous" })
		end,
	},

	-- ── friendly-snippets: the snippet collection ───────────────
	-- This is just a data package — LuaSnip loads it above.
	-- Listed separately so lazy.nvim can manage its updates.
	{ "rafamadriz/friendly-snippets" },
}
