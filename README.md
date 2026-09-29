<div align="center">

<img src="https://readme-typing-svg.demolab.com?font=JetBrains+Mono&weight=600&size=26&pause=1000&color=89B4FA&center=true&vCenter=true&width=700&lines=Akash's+Neovim+Config;Cyberpunk-Inspired+Transparent+UI;Optimized+for+Web+Development;Fast+%E2%80%A2+Modern+%E2%80%A2+Developer-Focused" alt="Typing SVG" />

<br/>

![Neovim](https://img.shields.io/badge/Neovim-0.12+-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Debian%20%2F%20Mint%20%2F%20Ubuntu-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Lua](https://img.shields.io/badge/Lua-5.1+-2C2D72?style=for-the-badge&logo=lua&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

</div>

---

A fast, modern Neovim configuration written entirely in Lua. Designed for web development with a transparent Catppuccin Mocha theme, VS Code-like muscle memory, native LSP integration, full Treesitter parsing, AI-assisted coding, and zero unnecessary bloat.

---

## 📖 Beginners: Understanding Key Notation & Modes

If you are new to Neovim, these symbols and letters in configs and keymap guides can seem cryptic. Here is what every symbol means:

### 1. What is the Leader Key (`<leader>`)?
In Vim and Neovim, the **Leader key** is a custom prefix key used to trigger shortcuts without conflicting with standard typing.
- In this configuration, **`<leader>` is set to the Spacebar (` `)**.
- Whenever you see `<leader>ff` or `Space f f`, it means: press and release `Space`, then press `f`, then press `f`.

### 2. Key Notation Cheat Sheet
| Notation | Meaning | Example |
|---|---|---|
| `<leader>` | The Spacebar (` `) | `<leader>e` = `Space` then `e` |
| `<C-...>` | **Ctrl** key | `<C-s>` = `Ctrl + S`, `<C-/>` = `Ctrl + /`, `<C-n>` = `Ctrl + N` |
| `<S-...>` | **Shift** key | `<S-h>` = `Shift + H` (capital `H`), `<S-F12>` = `Shift + F12` |
| `<A-...>` or `<M-...>` | **Alt** (Meta) key | `<A-j>` = `Alt + J` or `Alt + Down` (move line down) |
| `<CR>` | **Enter / Return** key (`Carriage Return`) | `:w<CR>` = type `:w` and hit `Enter` |
| `<Esc>` | **Escape** key | Return to Normal mode |
| `<Tab>` / `<S-Tab>` | **Tab** / **Shift + Tab** | Next / previous field or suggestion |
| `<BS>` | **Backspace** key | Delete character backwards |
| `<cmd>...<CR>` | Run an internal command silently without showing the command line prompt |

### 3. What do Mode Letters Mean? (`"n"`, `"i"`, `"v"`, `"x"`, `"t"`)
In Neovim configs, `map("n", ...)` tells Neovim in which mode a shortcut works:
- **`"n"` = Normal Mode:** The default navigation mode. Pressing keys moves the cursor, deletes, copies, or runs commands (it does not type text into the file). Press `Esc` anytime to get back here.
- **`"i"` = Insert Mode:** Text editing mode. You type characters directly into your file just like in VS Code or Notepad. Enter with `i` or `a`, exit with `Esc`.
- **`"v"` or `"x"` = Visual Mode:** Text selection mode. Allows you to highlight characters, lines, or blocks of code with your keyboard.
- **`"t"` = Terminal Mode:** The interactive terminal shell inside Neovim (e.g. ToggleTerm).
- **`map({ "n", "i", "x" }, "<C-s>", ...)`**: Means `Ctrl + S` saves your file whether you are in Normal, Insert, or Visual mode!

---

## ✨ Features

| Category | What's included |
|---|---|
| 🎨 UI | Catppuccin Mocha (transparent), Alpha dashboard, Bufferline (with offsets & LSP indicators), Lualine, Dropbar (breadcrumbs) |
| 🗂️ Navigation | Snacks Explorer sidebar, Snacks Picker (fuzzy finder, grep, buffers, commands), Oil.nvim (`-` or `<leader>o`) |
| 🧠 LSP | Mason (installer), nvim-lspconfig (native `vim.lsp.config`), Blink.cmp, Conform (auto-format on save) |
| 🌳 Syntax | Treesitter syntax highlighting & indentation, Treesitter Context (sticky scroll), autotag (auto-close & rename HTML/JSX tags) |
| 🔍 Diagnostics & Search | Tiny-inline-diagnostic, Trouble.nvim (`<leader>dt` / `<leader>xx`), Grug-far (`<leader>sr` project search & replace) |
| 🤖 AI | GitHub Copilot (inline ghost text), CopilotChat (floating chat) |
| 🌿 Git | Gitsigns (gutter indicators), Git-blame (inline commit details) |
| 💻 Terminal | ToggleTerm bottom panel (`<leader>t` or `Ctrl+\``) |
| ✨ Editing | Comment.nvim (`Ctrl+/`), Mini.nvim (`pairs`, `move`, `ai`, `surround`, `icons`), Highlight-colors (CSS swatches), Neoscroll, SmoothCursor, Visual-Multi |
| 💾 Sessions | Persistence.nvim (`<leader>qs` restore session, button on Alpha dashboard) |
| 🌐 Web Dev | Emmet LSP (properly scoped to markup/JSX), Markdown Preview (`<leader>mp`), Live Server (`<leader>ls`), non-intrusive auto-save |

---

## 📂 Structure

```text
~/.config/nvim/
├── init.lua                   ← entry point (loads bytecode cache, options, keymaps, autocmds, plugins)
├── lua/
│   ├── core/
│   │   ├── options.lua        ← editor settings (tabs, scrolloff, clipboard, timeoutlen, winborder)
│   │   ├── keymaps.lua        ← all keybindings (leader, picker, VS Code muscle memory)
│   │   └── autocmds.lua       ← UI state machine (Explorer ↔ Alpha, safe ghost-save, yank highlight)
│   └── plugins/
│       ├── init.lua           ← lazy.nvim bootstrap + disabled built-in plugins (rtp)
│       ├── snacks.lua         ← Explorer, Picker, Notifier, Indent guides, Zen mode
│       ├── ui.lua             ← Catppuccin, Alpha, Bufferline, Lualine, ToggleTerm, Oil, Dropbar, Trouble, Persistence
│       ├── lsp.lua            ← Mason, LSPconfig, Conform, Blink.cmp, Tiny-inline-diagnostic
│       ├── editor.lua         ← Treesitter, Sticky Scroll, Autotag, Mini suite, Comment.nvim, Grug-far, Highlight-colors
│       ├── git.lua            ← Gitsigns, Git-blame
│       ├── ai.lua             ← Copilot, CopilotChat
│       └── snippets.lua       ← LuaSnip + friendly-snippets collection
├── README.md
├── GUIDE.md                   ← complete beginner-to-advanced guide
├── lazy-lock.json
└── LICENSE
```

---

## 🚀 Installation & Requirements

### System Requirements
- **Neovim 0.11+ or 0.12+** (required for native `vim.lsp.config`, `vim.lsp.enable`, `vim.diagnostic.jump`, and `vim.hl.on_yank`).
  > ⚠️ Debian 13 / Ubuntu users: Check your package version with `apt policy neovim`. If your distro repository provides Neovim 0.10 or older, install the official [Neovim AppImage or GitHub release tarball](https://github.com/neovim/neovim/releases/latest).
- **Node.js 20+ or 22+** (required for Copilot, LSP language servers, and Markdown preview).
- **Git, Ripgrep, fd, GCC/Clang, Make, and a Clipboard tool (`xclip` on X11 or `wl-clipboard` on Wayland)**.

### 1. Backup existing config
```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

### 2. Clone this repository
```bash
git clone https://github.com/SniperRavan/Neovim.git ~/.config/nvim
```

### 3. Install system dependencies (Debian / Ubuntu / Mint)
```bash
sudo apt update && sudo apt install -y \
  git ripgrep fd-find nodejs npm \
  python3 gcc g++ clang curl wget unzip xclip
```
> For Wayland: replace `xclip` with `wl-clipboard`.

### 4. Install a Nerd Font
Download and install **JetBrainsMono Nerd Font** from [nerdfonts.com](https://www.nerdfonts.com/). Set it in your terminal emulator (e.g. Alacritty, Kitty, WezTerm):
```toml
# ~/.config/alacritty/alacritty.toml
[font]
normal = { family = "JetBrainsMono Nerd Font", style = "Regular" }
```

### 5. Launch Neovim
```bash
nvim
```
Plugins will download and install automatically on first launch. Then install formatters:
```vim
:MasonInstall prettier stylua
```

---

## ⚡ Performance Optimization & Disabled Built-in Plugins

This configuration optimizes startup time using two native methods:
1. `vim.loader.enable()` at the very top of `init.lua` for byte-compiled Lua caching.
2. Disabling legacy built-in Vim plugins that are not needed for modern web development:
   - `gzip` (reading gzip files as buffers)
   - `tarPlugin` (browsing tar files)
   - `tohtml` (converting buffers to raw HTML documents)
   - `zipPlugin` (browsing zip files)

### How to re-enable them
If you need to view `.zip` or `.tar` archives inside Neovim:
1. Open `lua/plugins/init.lua`.
2. Locate the `performance.rtp.disabled_plugins` table.
3. Remove or comment out `"zipPlugin"` or `"tarPlugin"`:
   ```lua
   disabled_plugins = {
     "gzip",
     -- "tarPlugin",
     "tohtml",
     -- "zipPlugin",
   },
   ```
4. Restart Neovim.

---

## ⌨️ Key Mappings Summary

Leader key: **`Space`**

### Explorer & Navigation
| Key | Action |
|---|---|
| `Space e` | Toggle file explorer sidebar |
| `-` or `Space o` | Open parent directory in Oil (filesystem editor) |
| `Space w h / j / k / l` | Move focus between split windows |
| `Ctrl + h / j / k / l` | Direct split window navigation |

### Search & Pickers (Snacks & Grug-Far)
| Key | Action |
|---|---|
| `Space f f` | Find project files (excludes `node_modules` and `.git`) |
| `Space f g` | Live grep (search text inside project files) |
| `Space f r` | Recent files |
| `Space f p` | Command palette |
| `Space f b` | Open buffers |
| `Space f s` | LSP symbols in current file |
| `Space f d` | Diagnostics picker |
| `Space f w` | Grep word under cursor |
| `Space f k` | Search all active keymaps |
| `Space g` | Global file search across home directory |
| `Space s r` | Search & Replace project-wide (Grug-far) |

### VS Code Muscle Memory (Additive)
| Key | Action |
|---|---|
| `Ctrl + s` | Save file (in Normal, Insert, and Visual modes) |
| `F2` | Rename symbol project-wide |
| `F12` | Go to definition |
| `Shift + F12` | Find all references |
| `Ctrl + .` | Quick fix / code actions |
| `Space c f` | Format document (Prettier / Stylua) |
| `Alt + Up / Down` | Move current line or selection up/down |
| `Shift + Arrow keys` | Select text character-by-character or line-by-line |

### Buffers & Tabs
| Key | Action |
|---|---|
| `Shift-L` / `Shift-H` | Next / previous buffer tab |
| `Ctrl-Tab` / `Ctrl-Shift-Tab` | Next / previous buffer tab |
| `]b` / `[b` | Built-in next / previous buffer |
| `Space x` | Close current buffer (returns to dashboard if last buffer) |

### Editing & Commenting
| Key | Action |
|---|---|
| `Ctrl + /` (or `Ctrl + _`) | Toggle line comment (JSX/HTML/JS context-aware) |
| `Space /` | Toggle block comment (`/* ... */`) |
| `Ctrl + n` | Multi-cursor (select word, press again for next instance) |

### Diagnostics & Terminal
| Key | Action |
|---|---|
| `Space d n` / `Space d p` | Next / previous diagnostic error |
| `Space d d` | Show diagnostic floating popup |
| `Space d t` or `Space x x` | Toggle Trouble problems panel |
| `Space t` or `Ctrl + \`` | Toggle bottom terminal panel |

### Sessions & Safe Quit
| Key | Action |
|---|---|
| `Space q s` | Restore session |
| `Space q l` | Restore last session |
| `Space q` | Safe quit Neovim (warns if unsaved files exist) |
| `Space Q` | Force quit Neovim (`:qa!`) |

---

## 🛠️ Essential Commands

```vim
:Lazy                 " Plugin manager interface (updates, profile, health)
:Lazy sync            " Synchronize and install all plugins
:Mason                " LSP, linter, and formatter manager interface
:MasonInstall prettier stylua
:checkhealth vim.lsp  " Verify LSP servers and diagnostics health
:checkhealth          " Full Neovim system and plugin health report
:TSUpdate             " Update Treesitter syntax parsers
```

---

## 📘 Comprehensive Guide

For in-depth explanations, vim motions, text objects, and customization tutorials, read **[GUIDE.md](GUIDE.md)**.
