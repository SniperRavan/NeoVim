-- ============================================================
--  core/keymaps.lua
--  All custom keybindings. Leader = Space.
--  Format: map(mode, keys, action, description)
-- ============================================================

local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ── File Explorer ─────────────────────────────────────────────
-- <leader>e → opens/closes the Snacks sidebar file tree.
-- The actual open/close logic lives in core/autocmds.lua (the state machine).
map("n", "<leader>e", function()
	-- We call the toggle helper defined in autocmds.lua
	-- It is exposed as a global so keymaps.lua stays clean.
	-- FIX: renamed from _G.ReclaimX_ToggleExplorer → _G.ToggleExplorer
	if _G.ToggleExplorer then
		_G.ToggleExplorer()
	end
end, { desc = "Toggle Sidebar Explorer" })

-- - → open the PARENT directory of the current file in Oil
-- Think of it like a file-manager buffer you can edit.
map("n", "-", "<cmd>Oil<CR>", { desc = "Open Parent Directory (Oil)" })

-- ── Global file search (home directory, ivy layout) ──────────
map("n", "<leader>g", function()
	Snacks.picker.files({
		-- FIX: vim.loop.os_homedir() deprecated in Neovim 0.10+
		-- vim.uv is the correct alias for the libuv bindings
		cwd = vim.uv.os_homedir(),
		hidden = true,
		ignored = true,
		layout = { preset = "ivy" },
	})
end, { desc = "Global File Search (Home)" })

-- ── Project search ────────────────────────────────────────────
-- <leader>ff → fuzzy find files in the current working directory
map("n", "<leader>ff", function()
	Snacks.picker.files({ cwd = vim.fn.getcwd(), hidden = true, ignored = true })
end, { desc = "Find Project Files" })

-- <leader>fg → search for text inside files (requires ripgrep)
map("n", "<leader>fg", function()
	Snacks.picker.grep({ cwd = vim.fn.getcwd(), hidden = true, ignored = true })
end, { desc = "Live Grep Project" })

-- <leader>fr → files you opened recently across all sessions
map("n", "<leader>fr", function()
	Snacks.picker.recent()
end, { desc = "Recent Files" })

-- ── Window navigation (split management) ─────────────────────
-- Move focus between open split windows without reaching for the mouse.
map("n", "<leader>h", "<C-w>h", { desc = "Focus Window Left" })
map("n", "<leader>l", "<C-w>l", { desc = "Focus Window Right" })
map("n", "<leader>j", "<C-w>j", { desc = "Focus Window Down" })
map("n", "<leader>k", "<C-w>k", { desc = "Focus Window Up" })

-- ── Buffer navigation ─────────────────────────────────────────
-- Shift+L / Shift+H cycles through open file tabs (bufferline).
map("n", "<S-l>", ":BufferLineCycleNext<CR>", { desc = "Next Buffer Tab" })
map("n", "<S-h>", ":BufferLineCyclePrev<CR>", { desc = "Prev Buffer Tab" })

-- <leader>x → close the current buffer without closing the window.
-- The autocmd in autocmds.lua then restores the Alpha dashboard automatically.
map("n", "<leader>x", ":bdelete<CR>", { desc = "Close Current Buffer" })

-- ── Terminal ──────────────────────────────────────────────────
-- <leader>t → open a floating terminal over everything.
-- Press <leader>t again (or Ctrl-\ Ctrl-n then <leader>t) to close.
-- NOTE: ToggleTerm loads via event = "VeryLazy" in plugins/ui.lua,
-- so it is guaranteed to be loaded before this keymap can fire.
map("n", "<leader>t", "<cmd>ToggleTerm<CR>", { desc = "Toggle Floating Terminal" })

-- ── AI / Copilot Chat ─────────────────────────────────────────
map({ "n", "v" }, "<leader>cc", "<cmd>CopilotChatToggle<CR>", { desc = "Toggle Copilot Chat" })
map({ "n", "v" }, "<leader>ce", "<cmd>CopilotChatExplain<CR>", { desc = "Copilot: Explain Code" })

-- ── Diagnostics (LSP error/warning navigation) ───────────────
-- Jump between errors/warnings detected by the language server.
map("n", "<leader>dn", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
map("n", "<leader>dp", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Show Diagnostic Popup" })

-- ── Web Dev tools ─────────────────────────────────────────────
map("n", "<leader>mp", ":MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })
map("n", "<leader>ls", ":LiveServerStart<CR>", { desc = "Start Live Server" })
map("n", "<leader>lx", ":LiveServerStop<CR>", { desc = "Stop Live Server" })

-- ── Quick quit ────────────────────────────────────────────────
-- Force-quit ALL windows. Useful when stuck.
map("n", "<leader>q", ":qa!<CR>", { desc = "Quit Neovim (force)" })

-- ── Clipboard notifications ───────────────────────────────────
-- Notify after yank so you know what got copied.
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("YankNotify", { clear = true }),
	callback = function()
		local count = #vim.v.event.regcontents
		vim.notify("Yanked " .. count .. " line(s)", vim.log.levels.INFO, { title = "Clipboard" })
	end,
})

-- dd in normal mode → delete line + notify
vim.keymap.set("n", "dd", function()
	vim.cmd("normal! dd")
	vim.notify("Line deleted", vim.log.levels.WARN, { title = "Delete" })
end)

-- d in visual mode → delete selection + notify
vim.keymap.set("v", "d", function()
	vim.cmd('normal! "zd')
	vim.notify("Selection deleted", vim.log.levels.WARN, { title = "Delete" })
end)

-- p in normal mode → paste + notify
vim.keymap.set("n", "p", function()
	vim.cmd("normal! p")
	vim.notify("Pasted", vim.log.levels.INFO, { title = "Clipboard" })
end)

-- ── Terminal: auto-enter insert mode, hide line numbers ───────
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("TermStyle", { clear = true }),
	callback = function()
		vim.cmd("startinsert")
		vim.wo.number = false
		vim.wo.relativenumber = false
	end,
})

-- ── Ghost auto-save for live preview ──────────────────────────
-- HTML/CSS/JS files save silently whenever you stop typing.
-- This keeps Live Server updated without you pressing :w.
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
	group = vim.api.nvim_create_augroup("GhostSave", { clear = true }),
	pattern = { "*.html", "*.css", "*.js" },
	callback = function()
		vim.cmd("silent! write")
	end,
})
