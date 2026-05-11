<div align="center">

<img src="https://readme-typing-svg.demolab.com?font=JetBrains+Mono&weight=600&size=26&pause=1000&color=89B4FA&center=true&vCenter=true&width=700&lines=Akash's+Neovim+Config;Cyberpunk-Inspired+Transparent+UI;Optimized+for+Debian+13+%2B+KDE+Plasma;Fast+%E2%80%A2+Minimal+%E2%80%A2+Developer-Focused" alt="Typing SVG" />

<br/>

![Neovim](https://img.shields.io/badge/Neovim-0.12+-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Debian%2013-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![KDE Plasma](https://img.shields.io/badge/KDE%20Plasma-Desktop-1D99F3?style=for-the-badge&logo=kdeplasma&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-5.1+-2C2D72?style=for-the-badge&logo=lua&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

</div>

---

A modern, modular Neovim configuration built with Lua. Designed for web development on Debian 13 + KDE Plasma with a transparent Catppuccin Mocha look, floating UI everywhere, LSP, AI-assisted coding, and a clean dashboard on startup.

---

## ✨ Features

| Category | What's included |
|----------|----------------|
| 🎨 UI | Catppuccin Mocha (transparent), Alpha dashboard, Bufferline, Lualine |
| 🗂️ Navigation | Snacks Explorer (sidebar), Snacks Picker (fuzzy find + live grep), Oil.nvim |
| 🧠 LSP | Mason, nvim-lspconfig, Blink.cmp (completion), Conform (format on save) |
| 🌳 Syntax | Treesitter (accurate highlighting + indentation) |
| 🤖 AI | GitHub Copilot (inline), CopilotChat (floating chat) |
| 🌿 Git | Gitsigns (gutter indicators), Git Blame (inline) |
| 💻 Terminal | ToggleTerm (floating, `<leader>t`) |
| ✨ Editor | Mini.nvim, Neoscroll, SmoothCursor, vim-visual-multi (multi-cursor) |
| 🌐 Web Dev | Markdown Preview, Live Server, ghost auto-save for HTML/CSS/JS |

---

## 📂 Structure

```text
~/.config/nvim/
├── init.lua                   ← entry point
├── lua/
│   ├── core/
│   │   ├── options.lua        ← editor settings
│   │   ├── keymaps.lua        ← all keybindings
│   │   └── autocmds.lua       ← UI state machine (Explorer ↔ Alpha logic)
│   └── plugins/
│       ├── init.lua           ← lazy.nvim bootstrap + imports
│       ├── snacks.lua         ← Explorer, Picker, Notifier, Zen
│       ├── ui.lua             ← Catppuccin, Alpha, Bufferline, Lualine, ToggleTerm, Oil
│       ├── lsp.lua            ← Mason, LSPconfig, Conform, Blink.cmp
│       ├── editor.lua         ← Treesitter, Mini, Neoscroll, SmoothCursor, Visual-Multi
│       ├── git.lua            ← Gitsigns, Git-blame
│       └── ai.lua             ← Copilot, CopilotChat
├── screenshots/
├── README.md
├── GUIDE.md                   ← complete beginner-to-advanced guide
├── lazy-lock.json
└── LICENSE
```

---

## 🚀 Installation

### 1. Backup existing config

```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

### 2. Clone

```bash
git clone https://github.com/SniperRavan/Neovim.git ~/.config/nvim
```

### 3. Install system dependencies (Debian 13)

```bash
sudo apt update && sudo apt install -y \
  neovim git ripgrep fd-find nodejs npm \
  python3 gcc g++ clang curl wget unzip xclip
```

> **Wayland users:** replace `xclip` with `wl-clipboard`

### 4. Set a Nerd Font in your terminal

Download **JetBrainsMono Nerd Font** from [nerdfonts.com](https://www.nerdfonts.com/) and set it in Alacritty:

```toml
# ~/.config/alacritty/alacritty.toml
[font]
normal = { family = "JetBrainsMono Nerd Font", style = "Regular" }
```

> Without a Nerd Font, the dashboard ASCII art and file icons will look broken.

### 5. Launch and sync

```bash
nvim
```

Plugins install automatically on first launch. Then run:

```vim
:MasonInstall prettier stylua
```

---

## ⌨️ Key Mappings

Leader key: **`Space`**

### Explorer & Navigation

| Key | Action |
|-----|--------|
| `Space e` | Toggle file explorer sidebar |
| `-` | Open parent directory (Oil) |
| `Space h/l/j/k` | Move between splits |

### Search

| Key | Action |
|-----|--------|
| `Space f f` | Find files in project |
| `Space f g` | Live grep (search text in files) |
| `Space f r` | Recent files |
| `Space g` | Global file search (home dir) |

### Buffers & Terminal

| Key | Action |
|-----|--------|
| `Shift-L / Shift-H` | Next / prev buffer tab |
| `Space x` | Close current buffer |
| `Space t` | Toggle floating terminal |

### LSP (active in code files)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `K` | Hover documentation |
| `gr` | Find references |
| `Space r n` | Rename symbol |
| `Space c a` | Code actions |
| `Space d n/p` | Next / prev diagnostic |
| `Space d d` | Diagnostic popup |

### AI

| Key | Action |
|-----|--------|
| `Ctrl-l` | Accept Copilot suggestion |
| `Space c c` | Toggle Copilot Chat |
| `Space c e` | Copilot explain selection |

### Web Dev

| Key | Action |
|-----|--------|
| `Space m p` | Toggle Markdown Preview |
| `Space l s / l x` | Start / Stop Live Server |

---

## 🔌 LSP Servers (auto-installed via Mason)

| Server | Language |
|--------|----------|
| `lua_ls` | Lua |
| `ts_ls` | TypeScript / JavaScript |
| `html` | HTML |
| `cssls` | CSS |

Add more in `lua/plugins/lsp.lua` → `ensure_installed`.

---

## 🛠️ Useful Commands

```vim
:Lazy           " Plugin manager UI
:Lazy sync      " Install / update / clean plugins
:Mason          " Tool installer UI
:MasonInstall prettier stylua
:checkhealth    " Full health report
:LspInfo        " LSP status for current file
:TSUpdate       " Update Treesitter parsers
```

---

## 📘 Full Guide

Everything — from opening a file for the first time, to LSP workflows, to adding plugins — is documented in **[GUIDE.md](GUIDE.md)**.

---

## 🐧 Platform

Designed for **Debian 13 + KDE Plasma**. Other distros work but are untested. Windows/macOS not supported.

---

<div align="center">

⚡ Built with Neovim + Lua · [SniperRavan/Neovim](https://github.com/SniperRavan/Neovim)

</div>
