-- ============================================================
--  core/autocmds.lua
--  THE UI STATE MACHINE
--
--  This file owns the logic for how Alpha (dashboard), Snacks
--  Explorer (sidebar), and regular file buffers co-exist.
--
--  State rules:
--    STARTUP            → Alpha full-screen (no explorer)
--    <leader>e pressed  → Explorer sidebar left, Alpha right
--    File opened        → Explorer left, file right
--    File closed        → Explorer left, Alpha right  (fallback)
--    <leader>e pressed  → Explorer closes, Alpha full-screen
--    All files closed (no explorer) → Alpha full-screen
-- ============================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ── Helper: is this buffer the Alpha dashboard? ──────────────
local function is_alpha(buf)
	return vim.bo[buf].filetype == "alpha"
end

-- ── Helper: is the Snacks explorer currently open? ───────────
local function explorer_is_open()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local ft = vim.bo[buf].filetype
		if ft == "snacks_explorer" or ft == "snacks-explorer" then
			return true, win
		end
	end
	return false, nil
end

-- ── Helper: count real file buffers (not alpha, not explorer) ─
local function real_file_buf_count()
	local count = 0
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if
			vim.api.nvim_buf_is_valid(buf)
			and vim.bo[buf].buflisted
			and vim.bo[buf].buftype == ""
			and vim.bo[buf].filetype ~= "alpha"
		then
			count = count + 1
		end
	end
	return count
end

-- ── Helper: open Alpha in the currently focused window ───────
local function open_alpha()
	-- Only open Alpha if there is no real file buffer visible in
	-- the current window. Prevents stomping on open files.
	local buf = vim.api.nvim_get_current_buf()
	if not is_alpha(buf) then
		vim.cmd("Alpha")
	end
end

-- ── Helper: open the Snacks explorer sidebar ─────────────────
local function open_explorer()
	Snacks.explorer.open({
		layout = {
			preset = "sidebar",
			position = "left",
			width = 30,
		},
	})
end

-- ── Helper: close the Snacks explorer sidebar ────────────────
local function close_explorer()
	local open, win = explorer_is_open()
	if open and win then
		vim.api.nvim_win_close(win, true)
	end
end

-- ── Global toggle (called by <leader>e in keymaps.lua) ───────
_G.ReclaimX_ToggleExplorer = function()
	if explorer_is_open() then
		close_explorer()
		-- After closing explorer, if there are no real files open,
		-- make the remaining window show Alpha.
		vim.schedule(function()
			if real_file_buf_count() == 0 then
				open_alpha()
			end
		end)
	else
		open_explorer()
		-- Move focus back to the right window (Alpha or open file)
		vim.schedule(function()
			local wins = vim.api.nvim_list_wins()
			for _, w in ipairs(wins) do
				local buf = vim.api.nvim_win_get_buf(w)
				local ft = vim.bo[buf].filetype
				if ft ~= "snacks_explorer" and ft ~= "snacks-explorer" then
					vim.api.nvim_set_current_win(w)
					break
				end
			end
		end)
	end
end

-- ── STARTUP: open Alpha when Neovim starts with no file args ──
autocmd("VimEnter", {
	group = augroup("AlphaStart", { clear = true }),
	callback = function()
		-- Only show Alpha when nvim was opened with no file argument.
		if vim.fn.argc() == 0 then
			vim.schedule(function()
				vim.cmd("Alpha")
			end)
		end
	end,
})

-- ── FALLBACK: when a buffer is deleted, check if we need Alpha ─
-- Fires after :bdelete, bufferline close, etc.
autocmd("BufDelete", {
	group = augroup("AlphaFallback", { clear = true }),
	callback = function()
		vim.schedule(function()
			-- Count remaining real file buffers
			if real_file_buf_count() == 0 then
				-- Find a window that isn't the explorer and show Alpha there
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local buf = vim.api.nvim_win_get_buf(win)
					local ft = vim.bo[buf].filetype
					if ft ~= "snacks_explorer" and ft ~= "snacks-explorer" then
						vim.api.nvim_set_current_win(win)
						open_alpha()
						return
					end
				end
				-- No other window found → just open Alpha
				open_alpha()
			end
		end)
	end,
})

-- ── GUARD: prevent Alpha from being listed as a buffer ────────
-- Alpha sets bufhidden=wipe, but this double-guards it.
autocmd("FileType", {
	group = augroup("AlphaGuard", { clear = true }),
	pattern = "alpha",
	callback = function(ev)
		vim.bo[ev.buf].buflisted = false
	end,
})
