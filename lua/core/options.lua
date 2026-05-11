-- ============================================================
--  core/options.lua
--  All vim.opt settings in one place.
--  These are the raw editor knobs — no plugin logic here.
-- ============================================================

local opt = vim.opt

-- ── Line numbers ─────────────────────────────────────────────
opt.number = true -- Show absolute line number on current line
opt.relativenumber = true -- Show relative numbers on all other lines

-- ── Indentation ──────────────────────────────────────────────
opt.tabstop = 2 -- A <Tab> character looks like 2 spaces
opt.shiftwidth = 2 -- >> and << indent by 2 spaces
opt.expandtab = true -- Insert spaces when you press <Tab>

-- ── Colors & transparency ────────────────────────────────────
opt.termguicolors = true -- Enable 24-bit RGB color (required for themes)

-- ── Smooth / glass feel ──────────────────────────────────────
opt.winblend = 10 -- Floating windows are 10% transparent
opt.pumblend = 10 -- Popup menu is 10% transparent

-- ── Cursor & gutter ──────────────────────────────────────────
opt.cursorline = true -- Highlight the line the cursor is on
opt.signcolumn = "yes" -- Always show the sign column (git signs, diagnostics)

-- ── Splits open in natural directions ───────────────────────
opt.splitright = true -- :vsplit opens the new window to the RIGHT
opt.splitbelow = true -- :split  opens the new window BELOW

-- ── Completion menu ──────────────────────────────────────────
opt.completeopt = { "menu", "menuone", "noselect" }

-- ── Clipboard ────────────────────────────────────────────────
-- Syncs Neovim's yank/paste with the system clipboard.
-- Requires: xclip (X11) or wl-clipboard (Wayland)
opt.clipboard = "unnamedplus"

-- ── Status & command area ────────────────────────────────────
opt.laststatus = 3 -- Single global statusline (not one per window)
opt.cmdheight = 0 -- Hide command bar when not typing a command
opt.showmode = false -- Don't show "-- INSERT --" (lualine handles this)

-- ── Misc UI ──────────────────────────────────────────────────
opt.shortmess:append("sI") -- Suppress intro screen / "search wrap" messages
opt.fillchars = { eob = " " } -- Hide the ~ marks on empty lines at end of buffer

-- ── Search ───────────────────────────────────────────────────
opt.ignorecase = true -- Case-insensitive search by default
opt.smartcase = true -- ...unless the query contains uppercase letters
opt.hlsearch = true -- Highlight all search matches
opt.incsearch = true -- Show matches as you type

-- ── Undo ─────────────────────────────────────────────────────
opt.undofile = true -- Persist undo history across sessions
