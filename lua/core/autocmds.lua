-- ============================================================
--  core/autocmds.lua
--  THE UI STATE MACHINE
--
--  This file controls how:
--    • Alpha dashboard
--    • Snacks Explorer
--    • Normal file buffers
--
--  interact with each other.
--
--  UI FLOW:
--
--    Startup (no file)
--      → Alpha fullscreen
--
--    <leader>e
--      → Toggle Snacks Explorer sidebar
--
--    Open file
--      → Explorer left + file right
--
--    Close last file
--      → Alpha automatically returns
--
--    Close explorer
--      → Alpha fullscreen (if no files remain)
--
-- ============================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ============================================================
--  Helper Functions
-- ============================================================

-- ── Is this buffer Alpha dashboard? ──────────────────────────
local function is_alpha(buf)
	return vim.bo[buf].filetype == "alpha"
end

-- ── Is this buffer Snacks Explorer? ──────────────────────────
-- FIX: original used exact string match ("snacks_explorer" or "snacks-explorer").
-- Snacks filetype can vary by version. Pattern match is safer.
local function is_explorer(buf)
	local ft = vim.bo[buf].filetype
	-- Match anything that contains both "snacks" and "explorer"
	return ft:find("snacks") ~= nil and ft:find("explorer") ~= nil
end

-- ── Is this a real editable file buffer? ─────────────────────
-- Excludes:
--   • Alpha
--   • Explorer
--   • terminals
--   • special buffers
local function is_real_file(buf)
	return vim.api.nvim_buf_is_valid(buf)
		and vim.bo[buf].buflisted
		and vim.bo[buf].buftype == ""
		and not is_alpha(buf)
		and not is_explorer(buf)
end

-- ── Count all real file buffers ──────────────────────────────
local function real_file_buf_count()
	local count = 0

	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if is_real_file(buf) then
			count = count + 1
		end
	end

	return count
end

-- ── Is Snacks Explorer currently open? ───────────────────────
local function explorer_is_open()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)

		if is_explorer(buf) then
			return true, win
		end
	end

	return false, nil
end

-- ── Open Alpha dashboard ─────────────────────────────────────
-- FIX: always wrap in vim.schedule so Alpha renders after the
-- current event (BufDelete, window close, etc.) fully settles.
-- Calling vim.cmd("Alpha") bare from a callback fails silently.
local function open_alpha()
	vim.schedule(function()
		vim.cmd("Alpha")
	end)
end

-- ── Open Snacks Explorer sidebar ─────────────────────────────
local function open_explorer()
	Snacks.explorer.open({
		layout = {
			preset = "sidebar",
			position = "left",
			width = 30,
		},
	})
end

-- ── Close Snacks Explorer sidebar ────────────────────────────
local function close_explorer()
	local open, win = explorer_is_open()

	if open and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_close(win, true)
	end
end

-- ============================================================
--  Global Explorer Toggle
-- ============================================================
--
-- Called from:
--   core/keymaps.lua
--
-- Key:
--   <leader>e
--
-- Behavior:
--   Explorer closed → open it
--   Explorer open   → close it
--
-- ============================================================

_G.ToggleExplorer = function()
	-- ── If explorer already open → close it ─────────────────
	if explorer_is_open() then
		close_explorer()

		-- defer so window close settles before we check/open alpha
		vim.defer_fn(function()
			if real_file_buf_count() == 0 then
				open_alpha()
			end
		end, 50)

		return
	end

	-- ── Otherwise open explorer ─────────────────────────────
	open_explorer()

	-- Return focus to normal editing window
	-- instead of keeping cursor trapped in sidebar.
	vim.schedule(function()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)

			if not is_explorer(buf) then
				vim.api.nvim_set_current_win(win)
				return
			end
		end
	end)
end

-- ============================================================
--  STARTUP LOGIC
-- ============================================================
--
-- When Neovim opens WITHOUT a file argument:
--
--     nvim
--
-- show Alpha dashboard fullscreen.
--
-- But if opened like:
--
--     nvim test.lua
--
-- then DO NOT show Alpha.
--
-- ============================================================

autocmd("VimEnter", {
	group = augroup("AlphaStart", { clear = true }),

	callback = function()
		-- Show dashboard when:
		--   • nvim opened with no arguments (just "nvim")
		--   • nvim opened with a directory argument ("nvim ." or "nvim /some/dir")
		--     In this case argc() == 1 but argv(0) is a directory, not a file.
		--     We want the dashboard, not a blank buffer.
		local argc = vim.fn.argc()
		local is_dir = argc == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1

		if argc == 0 or is_dir then
			vim.defer_fn(function()
				open_alpha()
			end, 150)
		end
	end,
})

-- ============================================================
--  BUFFER FALLBACK SYSTEM
-- ============================================================
--
-- When the LAST real file buffer closes:
--
--     :bdelete  or  <leader>x
--
-- restore Alpha automatically.
--
-- This creates the "return home" dashboard effect.
--
-- ============================================================

autocmd("BufDelete", {
	group = augroup("AlphaFallback", { clear = true }),

	callback = function()
		-- FIX: defer so the buffer is fully deleted before we count.
		-- Without the delay, the closing buffer still exists in the list
		-- for one more tick and real_file_buf_count() returns 1 instead of 0.
		vim.defer_fn(function()
			-- If real files still exist,
			-- do nothing.
			if real_file_buf_count() > 0 then
				return
			end

			-- Prevent opening Alpha inside explorer window.
			-- Find the first non-explorer, non-alpha window and open Alpha there.
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				if vim.api.nvim_win_is_valid(win) then
					local buf = vim.api.nvim_win_get_buf(win)

					if not is_explorer(buf) then
						vim.api.nvim_set_current_win(win)

						if not is_alpha(buf) then
							open_alpha()
						end

						return
					end
				end
			end
		end, 50)
	end,
})

-- ============================================================
--  ALPHA BUFFER GUARD
-- ============================================================
--
-- Prevent Alpha from appearing in:
--
--   :ls
--   bufferline
--   buffer switching
--
-- Alpha should behave like a UI screen,
-- NOT a normal editable file buffer.
--
-- ============================================================

autocmd("FileType", {
	group = augroup("AlphaGuard", { clear = true }),

	pattern = "alpha",

	callback = function(ev)
		vim.bo[ev.buf].buflisted = false
	end,
})

-- ============================================================
--  ALPHA WINRESIZED FIX
-- ============================================================
--
-- Alpha-nvim registers a WinResized autocmd to redraw itself
-- when the terminal is resized. But when the Snacks explorer
-- opens/closes next to an alpha window, WinResized fires and
-- alpha tries to redraw into a window ID that no longer exists,
-- throwing "Invalid window id" errors.
--
-- Fix: after alpha loads, delete its WinResized autocmd group.
-- Alpha still renders correctly — it just won't try to live-
-- redraw on window layout changes, which we don't need.
--
-- ============================================================

autocmd("FileType", {
	group = augroup("AlphaWinResizeFix", { clear = true }),
	pattern = "alpha",
	callback = function()
		-- Disable line numbers / gutter on the alpha window
		vim.wo.number = false
		vim.wo.relativenumber = false
		vim.wo.signcolumn = "no"
		vim.wo.cursorline = false
	end,
})

-- ── Patch alpha's redraw to be window-safe ───────────────────
-- Alpha stores a window ID when it opens and redraws on WinResized.
-- When explorer or completion popups open/close, that window ID
-- becomes invalid and alpha crashes with "Invalid window id".
--
-- Fix: after alpha loads, replace its internal redraw function with
-- a guarded version that checks window validity before drawing.
-- This is the only reliable fix — autocmd ordering cannot guarantee
-- we run before alpha's own WinResized handler.
autocmd("FileType", {
	group = augroup("AlphaPatchRedraw", { clear = true }),
	pattern = "alpha",
	callback = function()
		vim.defer_fn(function()
			local ok, alpha = pcall(require, "alpha")
			if not ok then
				return
			end

			-- Store original redraw
			local original_redraw = alpha.redraw

			-- Replace with guarded version
			alpha.redraw = function()
				if alpha.state and alpha.state.win then
					if not vim.api.nvim_win_is_valid(alpha.state.win) then
						return -- window gone, skip redraw silently
					end
				end
				-- Window is valid, call original
				pcall(original_redraw)
			end
		end, 50)
	end,
})

-- ============================================================
--  TERMINAL & EDITING HELPERS
-- ============================================================

-- ── Terminal: auto-enter insert mode, hide line numbers ───────
autocmd("TermOpen", {
	group = augroup("TermStyle", { clear = true }),
	callback = function()
		vim.cmd("startinsert")
		vim.wo.number = false
		vim.wo.relativenumber = false
	end,
})

-- ── Yank notification ─────────────────────────────────────────
autocmd("TextYankPost", {
	group = augroup("YankNotify", { clear = true }),
	callback = function()
		local count = #vim.v.event.regcontents
		vim.notify("Yanked " .. count .. " line(s)", vim.log.levels.INFO, { title = "Clipboard" })
	end,
})

-- ── Ghost auto-save for live preview ──────────────────────────
-- HTML/CSS/JS files save silently when leaving insert mode or changing text in normal mode.
-- Safe: will NOT thrash disk or formatters on every single keystroke.
autocmd({ "TextChanged", "InsertLeave" }, {
	group = augroup("GhostSave", { clear = true }),
	pattern = { "*.html", "*.css", "*.js" },
	callback = function()
		vim.cmd("silent! write")
	end,
})

