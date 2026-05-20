-- ============================================================
--  plugins/init.lua
--  Bootstraps lazy.nvim and imports each plugin spec file.
--  Add a new file under lua/plugins/ and require it here.
-- ============================================================

-- ── Bootstrap lazy.nvim ──────────────────────────────────────
-- lazy.nvim is the plugin manager. It clones itself on first run.
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

-- ── Load all plugin spec files ───────────────────────────────
require("lazy").setup({
	-- Each entry is a module under lua/plugins/
	{ import = "plugins.snacks" }, -- Explorer, Picker, Notifier, Zen
	{ import = "plugins.ui" }, -- Alpha, Bufferline, Lualine, ToggleTerm
	{ import = "plugins.lsp" }, -- Mason, LSPconfig, Conform, Blink.cmp
	{ import = "plugins.editor" }, -- Treesitter, Mini, Neoscroll, SmoothCursor
	{ import = "plugins.git" }, -- Gitsigns, Git-blame
	{ import = "plugins.ai" }, -- Copilot, CopilotChat
	{ import = "plugins.snippets" }, -- LuaSnip + friendly-snippets (boilerplates)
}, {
	rocks = { enabled = false }, -- Silence the LuaRocks health warning
	ui = { border = "rounded" }, -- Lazy's own UI uses rounded borders
})
