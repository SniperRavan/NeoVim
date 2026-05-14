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

		-- If no real files remain,
		-- restore Alpha dashboard.
		-- FIX: use defer_fn (not schedule) so the window close
		-- has fully settled before we try to open Alpha.
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
		-- Only show dashboard if no file argument exists
		if vim.fn.argc() == 0 then
			-- FIX: replace_netrw = true in snacks causes the explorer to
			-- auto-open when nvim starts in a directory, splitting the screen
			-- before alpha can render. We close it first, then open alpha.
			-- 150ms gives lazy.nvim time to finish loading all plugins.
			vim.defer_fn(function()
				-- Close the explorer if replace_netrw opened it automatically
				local open, win = explorer_is_open()
				if open and vim.api.nvim_win_is_valid(win) then
					vim.api.nvim_win_close(win, true)
				end

				-- Now open alpha into the remaining (or only) window
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
