-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Colors
vim.opt.termguicolors = true

-- Smooth + glass feel
vim.opt.winblend = 10
vim.opt.pumblend = 10

-- Cursor + UX
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"

-- Better splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Popup menu feel
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Sync Neovim clipboard with OS clipboard
vim.opt.clipboard = "unnamedplus"

-- Automatically updates cwd to current project
-- vim.opt.autochdir = true

-- Prevent intro-screen flickers fighting alpha
vim.opt.shortmess:append("sI")

