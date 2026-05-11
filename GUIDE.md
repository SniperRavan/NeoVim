# NEOVIM — Complete Neovim Guide

> This guide covers **your exact configuration** from first launch to advanced workflows.
> Every command listed here works in this setup. Nothing is generic.

---

## Table of Contents

1. [What is Neovim?](#1-what-is-neovim)
2. [Your Setup at a Glance](#2-your-setup-at-a-glance)
3. [Installation](#3-installation)
4. [First Launch — What Happens](#4-first-launch--what-happens)
5. [The Four Modes](#5-the-four-modes)
6. [Moving Around](#6-moving-around)
7. [Editing Text](#7-editing-text)
8. [Saving and Closing](#8-saving-and-closing)
9. [The File Explorer (Snacks)](#9-the-file-explorer-snacks)
10. [Opening and Switching Files](#10-opening-and-switching-files)
11. [Searching (Fuzzy Finder)](#11-searching-fuzzy-finder)
12. [The Floating Terminal](#12-the-floating-terminal)
13. [Language Servers (LSP)](#13-language-servers-lsp)
14. [Autocomplete (Blink.cmp)](#14-autocomplete-blinkcmp)
15. [Formatting on Save (Conform)](#15-formatting-on-save-conform)
16. [Mason — Installing Tools](#16-mason--installing-tools)
17. [Git Integration](#17-git-integration)
18. [AI Features (Copilot + Chat)](#18-ai-features-copilot--chat)
19. [Web Dev Tools](#19-web-dev-tools)
20. [Complete Keymap Reference](#20-complete-keymap-reference)
21. [Plugin Manager (Lazy.nvim)](#21-plugin-manager-lazynvim)
22. [Configuration File Structure](#22-configuration-file-structure)
23. [How to Add a Plugin](#23-how-to-add-a-plugin)
24. [How to Add a New LSP](#24-how-to-add-a-new-lsp)
25. [Troubleshooting](#25-troubleshooting)
26. [Vim Motions Cheat Sheet](#26-vim-motions-cheat-sheet)

---

## 1. What is Neovim?

Neovim is a text editor that runs inside your terminal. Unlike VS Code or Sublime Text, you control it entirely with the keyboard — no mouse required (though it works too).

The learning curve is steep for the first week, but once it clicks, you edit code faster than any GUI editor.

**Your version:** NVIM v0.12.2  
**Your config name:** NEOVIM  
**Your theme:** Catppuccin Mocha (transparent background, glass cyberpunk look)

---

## 2. Your Setup at a Glance

| What | Plugin/Tool | How to use |
|------|-------------|-----------|
| Plugin manager | lazy.nvim | `:Lazy` |
| Dashboard | alpha-nvim | Opens automatically |
| File explorer | snacks.nvim explorer | `Space e` |
| Fuzzy finder | snacks.nvim picker | `Space f f` |
| Autocomplete | blink.cmp | Appears as you type |
| LSP (smart code) | nvim-lspconfig + mason | Automatic |
| Formatter | conform.nvim | Runs on every save |
| Terminal | toggleterm.nvim | `Space t` |
| Git indicators | gitsigns.nvim | Visible in gutter |
| AI suggestions | copilot.lua | Appears as you type |
| AI chat | CopilotChat.nvim | `Space c c` |
| Colorscheme | catppuccin-mocha | Active always |
| Notifications | snacks.nvim notifier | Appears top-right |

---

## 3. Installation

### Step 1 — Back up any existing Neovim config

```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

### Step 2 — Clone this config

```bash
git clone https://github.com/yourusername/NEOVIM.git ~/.config/nvim
```

### Step 3 — Install system dependencies (Debian 13)

```bash
sudo apt update

sudo apt install -y \
  neovim git ripgrep fd-find nodejs npm \
  python3 gcc g++ clang curl wget unzip xclip
```

What each tool does:

| Tool | Why needed |
|------|-----------|
| `ripgrep` | Powers the live grep search (`Space f g`) |
| `fd-find` | Powers the file finder (`Space f f`) |
| `nodejs` + `npm` | Required for LSP servers, Copilot, Markdown Preview |
| `gcc` / `clang` | Compiles some plugins (Treesitter parsers) |
| `xclip` | Syncs clipboard between Neovim and your desktop (X11) |

> **Wayland users:** Replace `xclip` with `wl-clipboard`

### Step 4 — Install a Nerd Font

Icons in the explorer and statusline require a Nerd Font.

Download **JetBrainsMono Nerd Font** from https://www.nerdfonts.com/

Then in Alacritty config (`~/.config/alacritty/alacritty.toml`):

```toml
[font]
normal = { family = "JetBrainsMono Nerd Font", style = "Regular" }
```

> **This is why the ASCII art looks broken in your screenshots.**
> The box-drawing characters require the terminal font to be a Nerd Font.

### Step 5 — Launch Neovim

```bash
nvim
```

Plugins install automatically on first launch. Wait for them to finish.

### Step 6 — Install formatters

```vim
:MasonInstall prettier stylua
```

---

## 4. First Launch — What Happens

When you run `nvim` with no file argument:

1. `init.lua` loads → sets options, keymaps, autocmds
2. `lazy.nvim` loads all plugins
3. The **Alpha dashboard** appears full-screen
4. You see the NEOVIM header + six buttons

**Dashboard buttons** (press the shortcut shown on the right):

| Button | Shortcut | What it does |
|--------|----------|-------------|
| Find File | `f f` | Fuzzy search for files in current directory |
| New File | `f n` | Create a blank new file |
| Recent Files | `f r` | Files you opened recently |
| Find Text | `f g` | Search for text inside all files |
| Config | `f c` | Open your `init.lua` |
| Quit | `q` | Close Neovim |

---

## 5. The Four Modes

Neovim has modes. Understanding them is the single most important concept.

### NORMAL mode

**What it is:** The default mode. Keys perform commands, not type text.  
**How to get here:** Press `Escape` from any other mode.  
**Status bar shows:** `NORMAL`

This is where you spend most of your time: moving around, copying, deleting, searching.

### INSERT mode

**What it is:** Type text like a normal editor.  
**How to enter:** Press `i` (insert before cursor), `a` (after cursor), `o` (new line below).  
**How to exit:** Press `Escape`.  
**Status bar shows:** `INSERT`

### VISUAL mode

**What it is:** Select text.  
**How to enter:** Press `v` (character select), `V` (line select), `Ctrl-v` (block select).  
**How to exit:** Press `Escape`.  
**Status bar shows:** `VISUAL`

After selecting, you can:
- `d` → delete selection
- `y` → copy (yank) selection
- `>` / `<` → indent / outdent
- `<leader>cc` → send to Copilot Chat

### COMMAND mode

**What it is:** Type commands after `:`.  
**How to enter:** Press `:` from NORMAL mode.  
**How to exit:** Press `Escape` or `Enter` (to run the command).

Example: `:w` saves, `:q` quits.

---

## 6. Moving Around

All movement is done in **NORMAL mode**.

### Basic cursor movement

| Key | Move |
|-----|------|
| `h` | Left one character |
| `j` | Down one line |
| `k` | Up one line |
| `l` | Right one character |

### Word jumping

| Key | Move |
|-----|------|
| `w` | Jump forward to the start of the next word |
| `b` | Jump backward to the start of the previous word |
| `e` | Jump to the end of the current/next word |

### Line navigation

| Key | Move |
|-----|------|
| `0` | Go to the very beginning of the line |
| `^` | Go to the first non-space character on the line |
| `$` | Go to the end of the line |

### File navigation

| Key | Move |
|-----|------|
| `gg` | Go to the first line of the file |
| `G` | Go to the last line of the file |
| `50G` | Go to line 50 |
| `Ctrl-d` | Scroll down half a page (smooth, thanks to Neoscroll) |
| `Ctrl-u` | Scroll up half a page |
| `Ctrl-f` | Scroll down a full page |
| `Ctrl-b` | Scroll up a full page |

### Search

| Key | Action |
|-----|--------|
| `/searchterm` then `Enter` | Search forward for "searchterm" |
| `?searchterm` then `Enter` | Search backward |
| `n` | Jump to next match |
| `N` | Jump to previous match |
| `*` | Search for the word under the cursor |

---

## 7. Editing Text

### Entering insert mode

| Key | What it does |
|-----|-------------|
| `i` | Insert before the cursor |
| `a` | Insert after the cursor |
| `I` | Insert at the start of the line |
| `A` | Insert at the end of the line |
| `o` | Open a new line below and start inserting |
| `O` | Open a new line above and start inserting |

### Deleting

| Key | What it deletes |
|-----|----------------|
| `x` | The character under the cursor |
| `dd` | The entire current line (notifies you) |
| `dw` | From cursor to end of word |
| `d$` | From cursor to end of line |
| `diw` | The word under the cursor (without surrounding spaces) |
| `daw` | The word under the cursor (including surrounding spaces) |
| `di"` | Everything inside the nearest `"..."` |
| `di(` | Everything inside the nearest `(...)` |

### Changing (delete then immediately enter INSERT mode)

| Key | What it changes |
|-----|----------------|
| `cw` | From cursor to end of word |
| `ciw` | The entire word under cursor |
| `ci"` | Everything inside `"..."` |
| `ci(` | Everything inside `(...)` |
| `cc` | The entire current line |
| `C` | From cursor to end of line |

### Copying (yanking) and pasting

| Key | Action |
|-----|--------|
| `yy` | Copy (yank) the current line |
| `yw` | Yank from cursor to end of word |
| `y$` | Yank from cursor to end of line |
| `yiw` | Yank the word under cursor |
| `p` | Paste after the cursor (notifies you) |
| `P` | Paste before the cursor |

> Your clipboard is synced with the system clipboard (`vim.opt.clipboard = "unnamedplus"`).
> So `yy` in Neovim → `Ctrl-v` works in other apps, and vice versa.

### Undo and redo

| Key | Action |
|-----|--------|
| `u` | Undo the last change |
| `Ctrl-r` | Redo (undo the undo) |

### Indenting

| Key | Action |
|-----|--------|
| `>>` | Indent the current line right |
| `<<` | Indent the current line left |
| `>` in VISUAL | Indent selected lines right |
| `<` in VISUAL | Indent selected lines left |

### Multi-cursor (vim-visual-multi)

1. Place cursor on a word
2. Press `Ctrl-n` — it selects the word and adds a cursor
3. Press `Ctrl-n` again — finds and selects the next occurrence, adds another cursor
4. Keep pressing `Ctrl-n` to add more
5. Now type normally — all cursors edit simultaneously

---

## 8. Saving and Closing

### Saving

| Command | Action |
|---------|--------|
| `:w` | Save the current file |
| `:w filename.txt` | Save as a new file |
| `Space m p` | Toggle Markdown Preview (also saves) |

> Web files (`.html`, `.css`, `.js`) **auto-save as you type** — you never need `:w` for them.
> This keeps Live Server updated without any action from you.

### Closing buffers (file tabs)

| Key / Command | Action |
|--------------|--------|
| `Space x` | Close the current buffer (tab). If it's the last one, Alpha dashboard appears. |
| `:bdelete` | Same as above |
| `:bd!` | Force-close without saving |

> **Important:** Closing a buffer is NOT the same as closing the window.
> `Space x` closes the file. The window stays open and shows the dashboard.

### Closing Neovim

| Command | Action |
|---------|--------|
| `Space q` | Force quit ALL windows (even unsaved changes) |
| `:qa` | Quit all windows (fails if unsaved changes exist) |
| `:qa!` | Force quit all windows |
| `:wqa` | Save all + quit |

### Closing a split window

| Key | Action |
|-----|--------|
| `:q` | Close the currently focused window/split |
| `Ctrl-w c` | Close the current split |

---

## 9. The File Explorer (Snacks)

The explorer is the file tree on the left side of the screen.

### Opening and closing

Press **`Space e`** to toggle. Here's exactly what happens each time:

| Current state | Press `Space e` | Result |
|--------------|-----------------|--------|
| Dashboard fullscreen | → | Explorer opens left, Dashboard stays right |
| Explorer + Dashboard | → | Explorer closes, Dashboard fullscreen |
| Explorer + Open file | → | Explorer closes, file stays open fullscreen |
| No explorer, file open | → | Explorer opens left, file stays right |

### Navigating inside the explorer

Focus the explorer with `Space e`, then:

| Key | Action |
|-----|--------|
| `j` / `k` | Move down / up |
| `Enter` | Open file or expand folder |
| `l` | Expand folder |
| `h` | Collapse folder |
| `.` | Toggle hidden/dotfiles visibility |
| `a` | Create a new file (type the name, press Enter) |
| `d` | Delete the selected file |
| `r` | Rename the selected file |
| `q` or `Escape` | Close the explorer |

### Oil.nvim (alternative file manager)

Press **`-`** from any buffer to open the PARENT directory as an editable buffer.

This is powerful: you can:
- Rename files by editing the text on the line
- Delete files by deleting the line (`dd`)
- Create files by adding new lines
- Press `-` again to go up another directory
- Press `Enter` on a file to open it
- `:w` to apply your changes

---

## 10. Opening and Switching Files

### Opening files

| Method | How |
|--------|-----|
| From explorer | Navigate to file, press `Enter` |
| Fuzzy find | `Space f f` → type filename → `Enter` |
| Recent files | `Space f r` → select → `Enter` |
| Command | `:e path/to/file.js` |
| Oil | `-` to browse, `Enter` to open |

### Switching between open files (buffers)

| Key | Action |
|-----|--------|
| `Shift-L` | Go to the next buffer (right in the tab bar) |
| `Shift-H` | Go to the previous buffer (left in the tab bar) |
| `Space x` | Close the current buffer |

### Splits (multiple files side by side)

| Command | Action |
|---------|--------|
| `:vsplit` or `:vs` | Open current file in a vertical split (side by side) |
| `:split` or `:sp` | Open current file in a horizontal split (top/bottom) |
| `:vs filename.js` | Open a specific file in a vertical split |
| `Space h` | Move focus to the left split |
| `Space l` | Move focus to the right split |
| `Space j` | Move focus to the split below |
| `Space k` | Move focus to the split above |

---

## 11. Searching (Fuzzy Finder)

All search uses **Snacks Picker** — a fast fuzzy finder.

### Find files by name

Press **`Space f f`**

A floating window appears. Type any part of the filename.
- Use arrow keys or `j`/`k` to move through results
- Press `Enter` to open the file
- Press `Escape` to cancel

### Search text inside files

Press **`Space f g`** (requires `ripgrep` installed)

Type any text you want to find. Results update live as you type.
- The results show the filename and the matching line
- `Enter` to jump to that location

### Recent files

Press **`Space f r`**

Shows files you've opened across all previous Neovim sessions.

### Global search (anywhere on your computer)

Press **`Space g`**

Searches for files starting from your home directory (`~`).
Use this when you can't remember which project a file is in.

---

## 12. The Floating Terminal

Press **`Space t`** to open a floating terminal on top of everything.

The terminal runs your default shell (`$SHELL` — bash, zsh, fish, etc.).

### Inside the terminal

| Key | Action |
|-----|--------|
| Type normally | Run commands |
| `Ctrl-\` then `Ctrl-n` | Exit terminal INSERT mode → enter NORMAL mode |
| `Space t` (in NORMAL mode) | Close the terminal |

### Common workflow

```
Space t           → open terminal
npm run dev       → start your dev server
Ctrl-\ Ctrl-n     → go back to NORMAL mode without closing terminal
Space t           → hide terminal (it keeps running in background)
Space t           → show it again
```

---

## 13. Language Servers (LSP)

An LSP (Language Server Protocol) server is a program that understands your programming language. It runs silently in the background.

**What it gives you:**
- Red/yellow underlines on errors and warnings
- Autocomplete suggestions
- Jump to definition
- Rename a variable across the entire project
- Quick-fix suggestions

### Installed LSP servers

| Server | Language | Auto-installed? |
|--------|----------|----------------|
| `lua_ls` | Lua | Yes |
| `ts_ls` | TypeScript + JavaScript | Yes |
| `html` | HTML | Yes |
| `cssls` | CSS | Yes |

### LSP keymaps (active when a supported file is open)

| Key | Action |
|-----|--------|
| `gd` | **Go to definition** — jumps to where the function/variable is defined |
| `K` | **Hover docs** — shows documentation popup for what's under the cursor |
| `gr` | **Find references** — shows everywhere this symbol is used |
| `Space r n` | **Rename** — renames symbol everywhere in the project |
| `Space c a` | **Code action** — shows available quick-fixes (import missing, fix error, etc.) |

### Diagnostic navigation (errors/warnings)

| Key | Action |
|-----|--------|
| `Space d n` | Jump to the NEXT error/warning in the file |
| `Space d p` | Jump to the PREVIOUS error/warning |
| `Space d d` | Open a popup showing the full error message for the current line |

### Checking LSP status

```vim
:LspInfo
```

Shows which LSP server is attached to the current buffer and if it's running correctly.

---

## 14. Autocomplete (Blink.cmp)

As you type, a popup menu appears with suggestions. This works automatically — no trigger key needed.

### Completion sources

The popup combines suggestions from:
- **lsp** — functions, variables, and types from the language server
- **path** — file paths (when you type `./` or `/`)
- **snippets** — code templates
- **buffer** — words already in the current file

### Completion keymaps

| Key | Action |
|-----|--------|
| `Tab` | Select the next suggestion |
| `Shift-Tab` | Select the previous suggestion |
| `Enter` | Accept the selected suggestion |
| `Escape` | Close the completion menu |

### Signature help

When you type inside function arguments, a popup shows the function's expected parameters. This is automatic.

Example: typing `console.log(` shows that `log` expects `...data: any[]`.

---

## 15. Formatting on Save (Conform)

When you press `:w` to save, Conform automatically formats your code.

| File type | Formatter | Install with |
|-----------|-----------|-------------|
| JavaScript | prettier | `:MasonInstall prettier` |
| TypeScript | prettier | `:MasonInstall prettier` |
| HTML | prettier | `:MasonInstall prettier` |
| CSS | prettier | `:MasonInstall prettier` |
| JSON | prettier | `:MasonInstall prettier` |
| Lua | stylua | `:MasonInstall stylua` |

> **Nothing happens on save?** Run `:MasonInstall prettier stylua` — the formatters need to be installed first.

---

## 16. Mason — Installing Tools

Mason installs LSP servers, formatters, and linters.

### Open Mason UI

```vim
:Mason
```

A window appears showing all available and installed tools. Use `j`/`k` to navigate, `i` to install, `X` to uninstall.

### Install specific tools

```vim
:MasonInstall prettier
:MasonInstall stylua
:MasonInstall lua-language-server
:MasonInstall typescript-language-server
```

### Update all installed tools

```vim
:MasonUpdate
```

### Common Mason commands

| Command | Action |
|---------|--------|
| `:Mason` | Open the Mason UI |
| `:MasonInstall <name>` | Install a specific tool |
| `:MasonUninstall <name>` | Remove a tool |
| `:MasonUpdate` | Update all installed tools |
| `:MasonLog` | View Mason's log for debugging |

---

## 17. Git Integration

### Gitsigns — change indicators

When you're inside a git repository, the sign column (left of line numbers) shows:

| Symbol | Meaning |
|--------|---------|
| `│` (bar, usually green) | This line was modified |
| `+` (green) | This line was added |
| `_` (red) | A line above this was deleted |

These update in real time as you edit.

### Git blame

At the end of each line, you'll see: `You • 2 hours ago • Fixed the login bug`

This shows who last modified that line, when, and what commit message they wrote.

Toggle it with:
```vim
:GitBlameToggle
```

### Git workflow (using the terminal)

```
Space t                    → open floating terminal
git status                 → see what changed
git add .                  → stage all changes
git commit -m "your msg"   → commit
git push                   → push to remote
Ctrl-\ Ctrl-n              → back to normal mode
Space t                    → hide terminal
```

---

## 18. AI Features (Copilot + Chat)

### Copilot inline suggestions

As you type code, Copilot shows grey ghost-text suggestions.

| Key | Action |
|-----|--------|
| `Ctrl-l` | Accept the full Copilot suggestion |
| `Alt-]` | Next suggestion (cycle through alternatives) |
| `Alt-[` | Previous suggestion |

### First-time setup

```vim
:Copilot auth
```

Follow the instructions — it opens a browser to authenticate with GitHub.

### CopilotChat

| Key | Action |
|-----|--------|
| `Space c c` | Open/close the Copilot Chat window |
| `Space c e` | Ask Copilot to explain the selected code |

**How to use:**

1. Open a file with code
2. Press `Space c c` → a floating chat window appears
3. Type your question and press `Enter`
4. Copilot reads your file for context and responds

**With selected code:**

1. In VISUAL mode, select some code (`V` for line select)
2. Press `Space c c`
3. Ask a question — Copilot Chat knows what you selected

**Example questions:**
- "Explain what this function does"
- "Refactor this to use async/await"
- "Write unit tests for this code"
- "What's wrong with this code?"

---

## 19. Web Dev Tools

### Live Server

Starts a local web server that auto-reloads when files change.

```
Space l s     → Start Live Server
Space l x     → Stop Live Server
```

A browser tab opens pointing to your HTML file. Every time you save, the page reloads automatically.

> Requires: `npm install -g live-server`

**Your HTML/CSS/JS files auto-save as you type**, so the browser updates almost in real time without you pressing `:w`.

### Markdown Preview

```
Space m p     → Toggle Markdown Preview
```

Opens your `.md` file in the browser with live preview. The browser updates as you edit.

> Requires Node.js (should already be installed).

---

## 20. Complete Keymap Reference

`Space` = Leader key

### Explorer & Navigation

| Key | Action |
|-----|--------|
| `Space e` | Toggle file explorer sidebar |
| `-` | Open parent directory (Oil) |
| `Space h` | Focus split: left |
| `Space l` | Focus split: right |
| `Space j` | Focus split: down |
| `Space k` | Focus split: up |

### Search & Files

| Key | Action |
|-----|--------|
| `Space f f` | Find files in project |
| `Space f g` | Search text in files (live grep) |
| `Space f r` | Recent files |
| `Space g` | Global file search (home directory) |
| `Shift-L` | Next buffer/tab |
| `Shift-H` | Previous buffer/tab |
| `Space x` | Close current buffer |

### Terminal

| Key | Action |
|-----|--------|
| `Space t` | Toggle floating terminal |
| `Ctrl-\ Ctrl-n` | Exit terminal mode (while terminal is open) |

### LSP (active in code files)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `K` | Hover documentation |
| `gr` | Find references |
| `Space r n` | Rename symbol |
| `Space c a` | Code actions |
| `Space d n` | Next diagnostic |
| `Space d p` | Previous diagnostic |
| `Space d d` | Show diagnostic popup |

### AI

| Key | Action |
|-----|--------|
| `Ctrl-l` | Accept Copilot suggestion |
| `Space c c` | Toggle Copilot Chat |
| `Space c e` | Copilot: explain selection |

### Web Dev

| Key | Action |
|-----|--------|
| `Space m p` | Toggle Markdown Preview |
| `Space l s` | Start Live Server |
| `Space l x` | Stop Live Server |

### General

| Key | Action |
|-----|--------|
| `Space q` | Force quit Neovim |

---

## 21. Plugin Manager (Lazy.nvim)

Lazy.nvim handles installing, updating, and removing plugins.

### Open the Lazy UI

```vim
:Lazy
```

A window shows all installed plugins with their load times.

### Common Lazy commands

| Command | Action |
|---------|--------|
| `:Lazy` | Open the plugin manager UI |
| `:Lazy sync` | Install missing plugins + update + clean unused |
| `:Lazy update` | Update all plugins to latest versions |
| `:Lazy clean` | Remove plugins no longer in your config |
| `:Lazy profile` | Show startup time per plugin (find slow plugins) |
| `:Lazy health` | Check for problems |

### Inside the Lazy UI

| Key | Action |
|-----|--------|
| `U` | Update all plugins |
| `S` | Sync |
| `x` | Clean unused plugins |
| `q` | Close |

### Plugin lockfile

`lazy-lock.json` records the exact version of every installed plugin. This means:
- Your config is reproducible on any machine
- Updates don't break things unexpectedly
- You can roll back by restoring this file

---

## 22. Configuration File Structure

```
~/.config/nvim/
├── init.lua                    ← Entry point. Loads everything else.
├── lua/
│   ├── core/
│   │   ├── options.lua         ← Editor settings (tabs, numbers, clipboard…)
│   │   ├── keymaps.lua         ← All keybindings
│   │   └── autocmds.lua        ← UI state machine (Explorer+Alpha logic)
│   └── plugins/
│       ├── init.lua            ← Lazy.nvim bootstrap + imports
│       ├── snacks.lua          ← Explorer, Picker, Notifier, Zen
│       ├── ui.lua              ← Catppuccin, Alpha, Bufferline, Lualine, ToggleTerm, Oil
│       ├── lsp.lua             ← Mason, LSPconfig, Conform, Blink.cmp
│       ├── editor.lua          ← Treesitter, Mini, Neoscroll, SmoothCursor, Visual-Multi
│       ├── git.lua             ← Gitsigns, Git-blame
│       └── ai.lua              ← Copilot, CopilotChat
├── screenshots/
├── README.md
├── GUIDE.md                    ← This file
├── lazy-lock.json
└── LICENSE
```

### What to edit for common changes

| I want to… | Edit this file |
|-----------|---------------|
| Change a keymap | `lua/core/keymaps.lua` |
| Change editor behavior (tabs, numbers…) | `lua/core/options.lua` |
| Add a plugin | `lua/plugins/<relevant-file>.lua` |
| Change the colorscheme | `lua/plugins/ui.lua` (the catppuccin section) |
| Add a new LSP | `lua/plugins/lsp.lua` |
| Change the dashboard header | `lua/plugins/ui.lua` (the alpha section) |
| Change notification timeout | `lua/plugins/snacks.lua` |
| Change terminal shell | `lua/plugins/ui.lua` (the toggleterm section) |

---

## 23. How to Add a Plugin

1. Find the plugin on GitHub (e.g. `github.com/username/cool-plugin`)

2. Open the relevant file in `lua/plugins/`. For example, if it's an editor tool, open `lua/plugins/editor.lua`.

3. Add an entry to the return table:

```lua
-- lua/plugins/editor.lua

return {
  -- ... existing plugins ...

  -- Add this:
  {
    "username/cool-plugin",   -- The GitHub repo path
    event = "VeryLazy",       -- Load after startup (optional)
    config = function()
      require("cool-plugin").setup({
        -- plugin options go here
      })
    end,
  },
}
```

4. Save the file and run:

```vim
:Lazy sync
```

The plugin installs automatically.

### Lazy loading options (the `event` field)

| Value | When it loads |
|-------|-------------|
| `"VeryLazy"` | After the UI is ready (good default for most plugins) |
| `"BufReadPost"` | When you open a file |
| `"InsertEnter"` | When you enter INSERT mode |
| `{ "BufReadPost", "BufNewFile" }` | When you open any file |
| `cmd = "CommandName"` | Only when that command is run |
| `keys = "<leader>x"` | Only when that key is pressed |
| `ft = "lua"` | Only for that filetype |
| _(none / `lazy = false`)_ | At startup, always |

---

## 24. How to Add a New LSP

1. Find the server name on the mason-lspconfig list:
   https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers

2. Open `lua/plugins/lsp.lua`

3. In the `mason-lspconfig` section, add to `ensure_installed`:

```lua
ensure_installed = {
  "lua_ls",
  "ts_ls",
  "html",
  "cssls",
  "pyright",  -- ← add Python LSP here, for example
},
```

4. In the `nvim-lspconfig` section, add to the `servers` table:

```lua
local servers = {
  lua_ls  = { ... },
  ts_ls   = {},
  html    = {},
  cssls   = {},
  pyright = {},  -- ← add this
}
```

5. Save and run `:Lazy sync`. Mason will install `pyright` automatically.

---

## 25. Troubleshooting

### Icons look like boxes or question marks

Your terminal font is not a Nerd Font.  
Fix: Install JetBrainsMono Nerd Font and set it in Alacritty config.

### ASCII art on dashboard looks broken

Same as above — Nerd Font required.

### Clipboard doesn't work

Install `xclip` (X11) or `wl-clipboard` (Wayland):

```bash
sudo apt install xclip        # X11
sudo apt install wl-clipboard  # Wayland
```

### Colors look wrong / no transparency

1. Make sure your terminal emulator supports 24-bit color
2. In Alacritty, set `TERM=alacritty` or ensure `$COLORTERM=truecolor` is set
3. The config already sets `vim.opt.termguicolors = true`

### Plugin errors on startup

```vim
:Lazy sync
```

This reinstalls broken/missing plugins.

### LSP not working

```vim
:LspInfo
```

Check if a server is attached. If not:

```vim
:Mason
```

Make sure the server is installed (green checkmark).

### Treesitter highlighting wrong

```vim
:TSUpdate
```

This updates all language parsers.

### General health check

```vim
:checkhealth
```

Shows a full health report for Neovim and all plugins. Red items need fixing, yellow items are warnings.

### View error messages

```vim
:messages
```

Shows the last N messages/errors that appeared in the command area.

### Alpha dashboard and explorer fighting (wrong window focus)

If your dashboard and explorer ever appear in the wrong positions:

```vim
:qa
nvim
```

A fresh start always resolves layout issues. The state machine in `autocmds.lua` handles startup correctly.

---

## 26. Vim Motions Cheat Sheet

These are standard Vim commands that work everywhere.

### Text objects (combine with `d`, `c`, `y`, `v`)

| Object | Selects |
|--------|---------|
| `iw` | inner word (just the word) |
| `aw` | a word (word + space) |
| `i"` | inside `"..."` |
| `a"` | `"..."` including the quotes |
| `i(` | inside `(...)` |
| `i[` | inside `[...]` |
| `i{` | inside `{...}` |
| `ip` | inner paragraph |

Examples:
- `diw` = delete inner word
- `ci"` = change inside quotes (delete + enter INSERT)
- `yi(` = yank inside parentheses
- `va{` = visually select `{...}` including the braces

### Repeat & counts

| Pattern | Meaning |
|---------|---------|
| `5j` | Move down 5 lines |
| `3dd` | Delete 3 lines |
| `2w` | Jump forward 2 words |
| `.` | Repeat the last change |

### Marks (bookmarks)

| Key | Action |
|-----|--------|
| `ma` | Set mark `a` at current position |
| `` `a `` | Jump back to mark `a` |
| `''` | Jump back to last position before a jump |

### Replace

```vim
:%s/old/new/g          " Replace all occurrences in the file
:%s/old/new/gc         " Replace with confirmation for each
:10,20s/old/new/g      " Replace only on lines 10–20
```

### Macros (record and replay actions)

1. `qa` — start recording a macro into register `a`
2. Do your edits
3. `q` — stop recording
4. `@a` — play the macro
5. `5@a` — play it 5 times

---

*NEOVIM — built with Neovim + Lua on Debian 13 + KDE Plasma*
