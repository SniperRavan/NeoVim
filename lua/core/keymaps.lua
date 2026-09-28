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
-- Shift+L / Shift+H (or Ctrl+Tab / Ctrl+Shift+Tab) cycles through open file tabs (bufferline).
map("n", "<S-l>", ":BufferLineCycleNext<CR>", { desc = "Next Buffer Tab" })
map("n", "<S-h>", ":BufferLineCyclePrev<CR>", { desc = "Prev Buffer Tab" })
map("n", "<C-Tab>", ":BufferLineCycleNext<CR>", { desc = "Next Buffer Tab (Ctrl+Tab)" })
map("n", "<C-S-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Prev Buffer Tab (Ctrl+Shift+Tab)" })

-- <leader>x → close the current buffer without closing the window.
-- The autocmd in autocmds.lua then restores the Alpha dashboard automatically.
map("n", "<leader>x", ":bdelete<CR>", { desc = "Close Current Buffer" })

-- ── Selection with Shift + Arrow keys (VS Code muscle memory) ─
-- Normal mode: Shift + Arrows starts visual selection
map("n", "<S-Up>", "v<Up>", { desc = "Select Up" })
map("n", "<S-Down>", "v<Down>", { desc = "Select Down" })
map("n", "<S-Left>", "v<Left>", { desc = "Select Left" })
map("n", "<S-Right>", "v<Right>", { desc = "Select Right" })

-- Visual mode: Shift + Arrows extends selection
map("v", "<S-Up>", "<Up>", { desc = "Extend Selection Up" })
map("v", "<S-Down>", "<Down>", { desc = "Extend Selection Down" })
map("v", "<S-Left>", "<Left>", { desc = "Extend Selection Left" })
map("v", "<S-Right>", "<Right>", { desc = "Extend Selection Right" })

-- Insert mode: Shift + Arrows starts visual selection from cursor
map("i", "<S-Up>", "<Esc>v<Up>", { desc = "Select Up" })
map("i", "<S-Down>", "<Esc>v<Down>", { desc = "Select Down" })
map("i", "<S-Left>", "<Esc>v<Left>", { desc = "Select Left" })
map("i", "<S-Right>", "<Esc>v<Right>", { desc = "Select Right" })

-- ── Terminal (VS Code style bottom panel) ────────────────────
-- <leader>t or Ctrl+` toggles the bottom terminal panel.
-- While typing in terminal: Ctrl+` or Ctrl+t hides it immediately.
-- Press Esc Esc to enter normal mode in terminal to scroll or copy text.
-- When hidden, background commands keep running.
-- Type 'exit' (or Ctrl+d) in the terminal to terminate it.
map("n", "<leader>t", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal Panel (Bottom)" })
map("n", "<C-`>", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal Panel (Ctrl+`)" })
map("t", "<C-`>", "<cmd>ToggleTerm<CR>", { desc = "Hide Terminal Panel (Ctrl+`)" })
map("t", "<C-t>", "<cmd>ToggleTerm<CR>", { desc = "Hide Terminal Panel (Ctrl+t)" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit Terminal Mode to Normal Mode" })

-- ── AI / Copilot Chat ─────────────────────────────────────────
map({ "n", "v" }, "<leader>cc", "<cmd>CopilotChatToggle<CR>", { desc = "Toggle Copilot Chat" })
map({ "n", "v" }, "<leader>ce", "<cmd>CopilotChatExplain<CR>", { desc = "Copilot: Explain Code" })

-- ── Diagnostics (LSP error/warning navigation) ───────────────
-- Jump between errors/warnings detected by the language server.
map("n", "<leader>dn", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next Diagnostic" })
map("n", "<leader>dp", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Prev Diagnostic" })
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Show Diagnostic Popup" })

-- ── Web Dev tools ─────────────────────────────────────────────
map("n", "<leader>mp", ":MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })
map("n", "<leader>ls", ":LiveServerStart<CR>", { desc = "Start Live Server" })
map("n", "<leader>lx", ":LiveServerStop<CR>", { desc = "Stop Live Server" })

-- ── Quick quit ────────────────────────────────────────────────
-- Force-quit ALL windows. Useful when stuck.
map("n", "<leader>q", ":qa!<CR>", { desc = "Quit Neovim (force)" })
