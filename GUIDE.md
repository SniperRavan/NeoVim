# Neovim Setup Guide

## 1. Introduction

This document explains your complete Neovim setup in detail.

This is not a generic Neovim guide. Everything in this document is based on your actual configuration files, plugins, keymaps, UI setup, and workflow.

Your setup is designed around:

* Modern Lua-based Neovim configuration
* Beautiful UI and transparency
* Fast startup with lazy loading
* Web development workflow
* AI-assisted coding
* Git integration
* Smooth animations and modern editing experience
* Beginner-friendly keymaps with powerful advanced features

---

# Configuration Philosophy

Your setup follows these ideas:

* Minimal but visually powerful
* Fast startup performance
* Modern plugin ecosystem
* IDE-like experience while keeping Vim efficiency
* Floating UI everywhere
* Keyboard-first workflow
* Transparent Linux aesthetic
* Efficient project navigation

---

# Folder Structure

```text
nvim/
├── init.lua
├── lua/
│   ├── core/
│   │   ├── options.lua
│   │   └── keymaps.lua
│   └── plugins/
│       └── init.lua
├── screenshots/
├── ascii.txt
├── README.md
├── lazy-lock.json
└── LICENSE
```

---

# How Neovim Loads This Configuration

## Startup Flow

When Neovim starts:

1. `init.lua` loads first
2. `core/options.lua` loads editor settings
3. `core/keymaps.lua` loads all custom keybindings
4. `plugins/init.lua` loads Lazy.nvim
5. Lazy.nvim loads plugins
6. Plugin configurations execute
7. Dashboard opens
8. Snacks Explorer opens automatically

---

# init.lua

```lua
require("core.options")
require("core.keymaps")
require("plugins")
```

This file acts as the main entry point.

---

# 2. Installation & Setup

## Required Software

| Tool      | Purpose                         |
| --------- | ------------------------------- |
| Neovim    | Main editor                     |
| Git       | Plugin installation             |
| Nerd Font | Icons                           |
| ripgrep   | Fast searching                  |
| fd        | Fast file finding               |
| Node.js   | LSPs, Copilot, Markdown Preview |
| Python    | Some plugins/tools              |
| gcc/clang | Building plugins                |
| unzip     | Mason packages                  |
| curl      | Downloading dependencies        |

---

# Recommended Neovim Version

Use:

```bash
nvim --version
```

Recommended:

```text
Neovim >= 0.10
```

---

# Arch Linux Installation

```bash
sudo pacman -S neovim git ripgrep fd nodejs npm python gcc unzip curl wget
```

Install Nerd Fonts:

```bash
sudo pacman -S ttf-jetbrains-mono-nerd
```

---

# Ubuntu/Debian Installation

```bash
sudo apt update
sudo apt install neovim git ripgrep fd-find nodejs npm python3 gcc unzip curl wget
```

---

# Fedora Installation

```bash
sudo dnf install neovim git ripgrep fd-find nodejs npm python3 gcc unzip curl wget
```

---

# Clipboard Support

Linux clipboard tools:

## Wayland

```bash
sudo pacman -S wl-clipboard
```

## X11

```bash
sudo pacman -S xclip
```

---

# 3. Plugin Manager

Your setup uses:

# Lazy.nvim

Plugin:

* `folke/lazy.nvim`

Purpose:

* Fast plugin manager
* Lazy loading
* Plugin profiling
* Dependency management
* Lockfile support

---

# How Lazy.nvim Works

Lazy.nvim:

1. Clones plugins into:

```text
~/.local/share/nvim/lazy/
```

2. Loads plugins only when needed
3. Reduces startup time
4. Handles dependencies automatically

---

# lazy-lock.json

This file locks plugin versions.

Purpose:

* Prevent breaking updates
* Ensure stable setup
* Reproducible configuration

---

# Important Lazy Commands

## Open Lazy UI

```vim
:Lazy
```

Shows:

* Installed plugins
* Startup times
* Updates
* Errors
* Dependencies

---

## Install Missing Plugins

```vim
:Lazy sync
```

Does:

* Install missing plugins
* Update plugins
* Remove unused plugins

---

## Update Plugins

```vim
:Lazy update
```

---

## Remove Unused Plugins

```vim
:Lazy clean
```

---

## Plugin Startup Profiling

```vim
:Lazy profile
```

Shows slow plugins.

---

## Health Check

```vim
:Lazy health
```

---

# 4. Mason / LSP / Formatter / Linter Guide

# What is Mason?

Plugin:

* `williamboman/mason.nvim`

Purpose:

* Install language servers
* Install formatters
* Install linters
* Install DAP adapters

Mason acts like a package manager for coding tools.

---

# LSP vs Formatter vs Linter vs DAP

| Tool      | Purpose               |
| --------- | --------------------- |
| LSP       | Smart coding features |
| Formatter | Code formatting       |
| Linter    | Code warnings/errors  |
| DAP       | Debugging             |

---

# Mason Commands

## Open Mason

```vim
:Mason
```

---

## Install Tool

```vim
:MasonInstall lua-language-server
```

---

## Remove Tool

```vim
:MasonUninstall lua-language-server
```

---

## Update Registry

```vim
:MasonUpdate
```

---

# Installed LSP Servers

## lua_ls

Language:

* Lua

Purpose:

* Lua autocomplete
* Diagnostics
* Hover docs
* Go to definition

Configured Globals:

```lua
vim
```

This prevents warnings about Neovim API usage.

---

## ts_ls

Language:

* TypeScript
* JavaScript

Purpose:

* IntelliSense
* Type checking
* Refactoring

---

## html

Language:

* HTML

Features:

* Tag autocomplete
* Attribute suggestions

---

## cssls

Language:

* CSS

Features:

* CSS property autocomplete
* Diagnostics

---

# LSP Keymaps

| Keymap     | Action           |
| ---------- | ---------------- |
| gd         | Go to definition |
| K          | Hover docs       |
| <leader>rn | Rename symbol    |
| <leader>ca | Code actions     |

---

# 5. Keymaps Reference

# Leader Key

Your leader key:

```text
Space
```

So:

```text
<leader>e
```

means:

```text
Space + e
```

---

# Main Keymaps

| Keymap     | Mode          | Action            | Description               |
| ---------- | ------------- | ----------------- | ------------------------- |
| <leader>e  | Normal        | Toggle Explorer   | Opens Snacks sidebar      |
| -          | Normal        | Open Oil          | Parent directory explorer |
| <leader>g  | Normal        | Global Search     | Search home directory     |
| <leader>ff | Normal        | Find Files        | Search project files      |
| <leader>fg | Normal        | Live Grep         | Search text in project    |
| <leader>fr | Normal        | Recent Files      | Recently opened files     |
| <leader>h  | Normal        | Window Left       | Move left split           |
| <leader>j  | Normal        | Window Down       | Move down split           |
| <leader>k  | Normal        | Window Up         | Move up split             |
| <leader>l  | Normal        | Window Right      | Move right split          |
| <S-l>      | Normal        | Next Buffer       | Cycle next buffer         |
| <S-h>      | Normal        | Previous Buffer   | Cycle previous buffer     |
| <leader>x  | Normal        | Close Buffer      | Delete current buffer     |
| <leader>t  | Normal        | Toggle Terminal   | Floating terminal         |
| <leader>cc | Normal/Visual | Copilot Chat      | AI chat                   |
| <leader>ce | Normal/Visual | Explain Code      | AI explanation            |
| <leader>q  | Normal        | Quit Neovim       | Force quit                |
| <leader>mp | Normal        | Markdown Preview  | Toggle preview            |
| <leader>ls | Normal        | Start Live Server | Web dev server            |
| <leader>lx | Normal        | Stop Live Server  | Stop server               |
| <leader>dn | Normal        | Next Diagnostic   | Jump errors               |
| <leader>dp | Normal        | Prev Diagnostic   | Previous error            |
| <leader>dd | Normal        | Diagnostics Popup | Floating diagnostics      |

---

# 6. Core Vim Motions & Editing

# Basic Movement

| Key | Action |
| --- | ------ |
| h   | Left   |
| j   | Down   |
| k   | Up     |
| l   | Right  |

---

# Word Motions

| Key | Action        |
| --- | ------------- |
| w   | Next word     |
| b   | Previous word |
| e   | End of word   |

---

# Line Navigation

| Key | Action          |
| --- | --------------- |
| 0   | Start of line   |
| ^   | First non-space |
| $   | End of line     |

---

# File Navigation

| Key | Action         |
| --- | -------------- |
| gg  | Top of file    |
| G   | Bottom of file |

---

# Editing Commands

| Command | Meaning              |
| ------- | -------------------- |
| yy      | Copy line            |
| dd      | Delete line          |
| p       | Paste                |
| u       | Undo                 |
| Ctrl-r  | Redo                 |
| ciw     | Change inner word    |
| diw     | Delete inner word    |
| di"     | Delete inside quotes |

---

# Visual Mode

## Enter Visual Mode

```vim
v
```

## Line Visual Mode

```vim
V
```

## Block Visual Mode

```vim
Ctrl-v
```

---

# Searching

## Search

```vim
/search_term
```

## Next Result

```vim
n
```

## Previous Result

```vim
N
```

---

# Replace

```vim
:%s/old/new/g
```

---

# 7. File Management

# Basic File Commands

| Command | Purpose         |
| ------- | --------------- |
| :e file | Open file       |
| :w      | Save            |
| :q      | Quit            |
| :wq     | Save and quit   |
| :x      | Save and exit   |
| :bd     | Delete buffer   |
| :bn     | Next buffer     |
| :bp     | Previous buffer |

---

# Snacks Explorer

Plugin:

* `folke/snacks.nvim`

Purpose:

* Sidebar file explorer
* Floating UI
* File navigation

Keymap:

```text
<leader>e
```

Features:

* Sidebar layout
* Hidden file toggle
* Git awareness
* Integrated navigation

---

# Oil.nvim

Plugin:

* `stevearc/oil.nvim`

Purpose:

* Edit filesystem like a buffer

Keymap:

```text
-
```

---

# 8. Search & Navigation

# Snacks Picker

Acts similarly to Telescope.

Features:

* Fuzzy finding
* Live grep
* Recent files
* Project search

---

# Find Files

```text
<leader>ff
```

Uses:

* fd
  n- fuzzy matching

---

# Live Grep

```text
<leader>fg
```

Requires:

* ripgrep

Example:

Search:

```text
useState
```

across project instantly.

---

# 9. Treesitter

Plugin:

* `nvim-treesitter/nvim-treesitter`

Purpose:

* Modern syntax highlighting
* Better parsing
* Smart indentation
* Better language understanding

---

# Installed Parsers

```lua
lua
javascript
html
css
typescript
vim
vimdoc
markdown
```

---

# Treesitter Commands

## Install Parser

```vim
:TSInstall rust
```

## Update Parsers

```vim
:TSUpdate
```

---

# 10. Git Integration

# Gitsigns

Plugin:

* `lewis6991/gitsigns.nvim`

Purpose:

* Git diff indicators
* Hunk management
* Git integration inside editor

---

# Git Blame

Plugin:

* `f-person/git-blame.nvim`

Purpose:

* Show who changed line
* Show commit info

---

# Git Workflow Example

1. Open file
2. Edit code
3. View changed lines
4. Stage with Git CLI
5. Commit

---

# 11. Terminal Usage

Plugin:

* `akinsho/toggleterm.nvim`

Purpose:

* Floating terminal
* Integrated shell

Keymap:

```text
<leader>t
```

---

# Exit Terminal Mode

```vim
Ctrl-\\ Ctrl-n
```

---

# Example Workflow

```text
<leader>t
npm run dev
```

---

# 12. Autocompletion

Plugin:

* `saghen/blink.cmp`

Purpose:

* Fast autocomplete engine

Features:

* LSP suggestions
* Snippets
* Buffer suggestions
* Path suggestions

---

# Completion Sources

| Source   | Purpose              |
| -------- | -------------------- |
| lsp      | Language server      |
| path     | File paths           |
| snippets | Snippets             |
| buffer   | Current buffer words |

---

# Completion Keymaps

| Key       | Action              |
| --------- | ------------------- |
| Tab       | Next suggestion     |
| Shift-Tab | Previous suggestion |
| Enter     | Accept suggestion   |

---

# 13. Themes & UI

# Colorscheme

Plugin:

* `catppuccin/nvim`

Flavor:

```text
catppuccin-mocha
```

Features:

* Transparency
* Modern colors
* Plugin integrations

---

# Transparency

Configured using:

```lua
Normal = { bg = "NONE" }
```

---

# Bufferline

Plugin:

* `akinsho/bufferline.nvim`

Purpose:

* Modern tab-like buffers

---

# Lualine

Plugin:

* `nvim-lualine/lualine.nvim`

Purpose:

* Statusline

---

# Dashboard

Plugin:

* `goolord/alpha-nvim`

Features:

* ASCII art
* Buttons
* Startup dashboard

---

# Notifications

Plugin:

* `folke/snacks.nvim`

Purpose:

* Fancy notifications
* Clipboard notifications
* Delete notifications
* Paste notifications

---

# 14. Commands Cheat Sheet

# File Commands

```vim
:e
:w
:q
:wq
:x
```

---

# Buffer Commands

```vim
:bd
:bn
:bp
```

---

# Lazy Commands

```vim
:Lazy
:Lazy sync
:Lazy update
:Lazy clean
:Lazy profile
```

---

# Mason Commands

```vim
:Mason
:MasonInstall
:MasonUninstall
:MasonUpdate
```

---

# LSP Commands

```vim
:LspInfo
```

---

# Treesitter Commands

```vim
:TSInstall
:TSUpdate
```

---

# 15. Troubleshooting

# Common Debug Commands

## Health Check

```vim
:checkhealth
```

---

## LSP Info

```vim
:LspInfo
```

---

## View Messages

```vim
:messages
```

---

# Common Problems

## Clipboard Not Working

Install:

```bash
wl-clipboard
```

or:

```bash
xclip
```

---

## Treesitter Errors

Run:

```vim
:TSUpdate
```

---

## Plugin Errors

Run:

```vim
:Lazy sync
```

---

# 16. Advanced Concepts

# require()

Used to load Lua modules.

Example:

```lua
require("core.options")
```

---

# vim.opt

Used to set editor options.

Example:

```lua
vim.opt.number = true
```

---

# vim.keymap.set

Used to create mappings.

Example:

```lua
vim.keymap.set("n", "<leader>q", ":qa!<CR>")
```

---

# Autocommands

Automatically run actions on events.

Example:

```lua
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    print("yanked")
  end,
})
```

---

# 17. Customization Guide

# Add Plugin

Inside:

```text
lua/plugins/init.lua
```

Add:

```lua
{
  "plugin/name",
  config = function()
  end,
}
```

Then run:

```vim
:Lazy sync
```

---

# Add LSP

Inside Mason config:

```lua
ensure_installed = {
  "rust_analyzer"
}
```

---

# Add Formatter

Inside conform:

```lua
rust = { "rustfmt" }
```

---

# Change Theme

Replace:

```lua
vim.cmd.colorscheme("catppuccin-mocha")
```

---

# 18. Installed Plugins

# folke/snacks.nvim

Purpose:

* Explorer
* Picker
* Notifications
* Zen mode

Features:

* Sidebar explorer
* Fuzzy search
* Floating UI
* Fancy notifications

---

# folke/which-key.nvim

Purpose:

* Popup showing keymaps

---

# catppuccin/nvim

Purpose:

* Colorscheme

---

# stevearc/oil.nvim

Purpose:

* Filesystem editing

---

# nvim-treesitter/nvim-treesitter

Purpose:

* Syntax parsing

---

# zbirenbaum/copilot.lua

Purpose:

* GitHub Copilot integration

---

# CopilotC-Nvim/CopilotChat.nvim

Purpose:

* AI chat inside Neovim

---

# nvim-lualine/lualine.nvim

Purpose:

* Statusline

---

# akinsho/bufferline.nvim

Purpose:

* Buffer tabs

---

# akinsho/toggleterm.nvim

Purpose:

* Floating terminal

---

# karb94/neoscroll.nvim

Purpose:

* Smooth scrolling

---

# gen740/SmoothCursor.nvim

Purpose:

* Animated cursor

---

# echasnovski/mini.nvim

Modules Used:

* mini.ai
* mini.surround
* mini.icons

---

# mg979/vim-visual-multi

Purpose:

* Multi-cursor editing

---

# goolord/alpha-nvim

Purpose:

* Startup dashboard

---

# lewis6991/gitsigns.nvim

Purpose:

* Git indicators

---

# rachartier/tiny-inline-diagnostic.nvim

Purpose:

* Inline diagnostics

---

# williamboman/mason.nvim

Purpose:

* External tool installer

---

# neovim/nvim-lspconfig

Purpose:

* Configure LSP servers

---

# stevearc/conform.nvim

Purpose:

* Formatting engine

---

# saghen/blink.cmp

Purpose:

* Completion engine

---

# 19. Workflow Examples

# Web Development Workflow

1. Open project
2. `<leader>e` for explorer
3. `<leader>ff` find files
4. `<leader>ls` start live server
5. `<leader>t` open terminal
6. Edit code
7. Autoformat on save
8. Use Copilot suggestions

---

# Git Workflow

1. Open file
2. Edit code
3. See git signs
4. Check blame info
5. Commit using terminal

---

# Refactoring Workflow

1. Place cursor on variable
2. Press:

```text
<leader>rn
```

3. Rename symbol project-wide

---

# Search Workflow

1. Press:

```text
<leader>fg
```

2. Search function name
3. Jump to result

---

# 20. Personal Notes Section

# Favorite Commands

```text
```

---

# Favorite Workflows

```text
```

---

# Future Plugin Ideas

```text
```

---

# TODO

```text
```

