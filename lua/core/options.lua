local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

-- Colors & transparency
opt.termguicolors = true
opt.winblend = 10
opt.pumblend = 10

-- Cursor & gutter
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 8

-- Splits open in natural directions
opt.splitright = true
opt.splitbelow = true

-- Completion & preview
opt.completeopt = { "menu", "menuone", "noselect" }
opt.inccommand = "split"

-- Clipboard (syncs with system clipboard via xclip or wl-clipboard)
opt.clipboard = "unnamedplus"

-- Status & command area
opt.laststatus = 3
opt.cmdheight = 0
opt.showmode = false

-- Interface & responsiveness
opt.timeoutlen = 300
opt.updatetime = 250
opt.confirm = true
opt.winborder = "rounded"
opt.shortmess:append("sI")
opt.fillchars = { eob = " " }

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Undo
opt.undofile = true

-- Selection (Shift + Arrows for VS Code muscle memory)
opt.keymodel = "startsel,stopsel"
