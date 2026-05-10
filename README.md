# Akash's Neovim Config

A modern, visual-first Neovim setup for Windows & Linux with a transparent Catppuccin look, a custom Alpha dashboard, floating terminal workflow, file explorer, Telescope search, LSP, autoformatting, and frontend-friendly utilities such as Markdown Preview and Live Server.

This repository is designed to be cloned directly into the Neovim config directory and used as a personal daily-driver configuration. The layout is modular, easy to edit, and built with `lazy.nvim` for plugin management and reproducible installs through a lockfile.

<div align="center">

<img src="https://readme-typing-svg.demolab.com?font=JetBrains+Mono&weight=600&size=26&pause=1000&color=89B4FA&center=true&vCenter=true&width=700&lines=Modern+Lua-Based+Neovim+Setup;Cyberpunk-Inspired+Transparent+UI;Optimized+for+Debian+13+%2B+KDE+Plasma;Fast+%E2%80%A2+Minimal+%E2%80%A2+Developer-Focused" alt="Typing SVG" />

<br/>

![Neovim](https://img.shields.io/badge/Neovim-0.10+-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Debian%2013-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![KDE Plasma](https://img.shields.io/badge/KDE%20Plasma-Desktop-1D99F3?style=for-the-badge&logo=kdeplasma&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-5.1+-2C2D72?style=for-the-badge&logo=lua&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

</div>

---

## ✨ Overview

RECLAIMX is a modern Neovim configuration built with Lua and designed primarily for:

- 🐧 Debian 13
- 🖥️ KDE Plasma
- 🌐 Web development
- ⚡ Fast workflows
- 🤖 AI-assisted coding
- 🎨 Transparent cyberpunk-inspired UI

This setup focuses on:
- performance
- clean architecture
- modern tooling
- smooth UX
- minimal clutter

Unlike traditional Vim setups, RECLAIMX aims to provide a modern IDE-like experience while keeping Neovim lightweight and highly customizable.

---

## ⚡ Core Features

<table>
<tr>
<td>

### 🚀 Performance
- Lazy-loaded plugins
- Optimized startup
- Event-based loading
- Minimal overhead

</td>
<td>

### 🎨 UI / UX
- Catppuccin Mocha
- Transparent windows
- Smooth scrolling
- Animated cursor
- Floating UI

</td>
</tr>

<tr>
<td>

### 🧠 Development
- LSP support
- Mason tooling
- Auto formatting
- Diagnostics
- Treesitter parsing

</td>
<td>

### 🤖 AI Workflow
- GitHub Copilot
- Copilot Chat
- Inline diagnostics
- Smart completion

</td>
</tr>
</table>

---

# 🖼️ Preview

> Screenshots will be added later.

<div align="center">

| Dashboard | Editing |
|---|---|
| `screenshots/dashboard.png` | `screenshots/editing.png` |

| Explorer | Terminal |
|---|---|
| `screenshots/explorer.png` | `screenshots/terminal.png` |

</div>

---

# 📂 Configuration Structure

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
├── README.md
├── Guide.md
├── lazy-lock.json
└── LICENSE
```

| File / Folder | Purpose |
|---|---|
| `init.lua` | Main Neovim entry point |
| `core/` | Core editor configuration |
| `plugins/` | Plugin definitions and setup |
| `lazy-lock.json` | Locked plugin versions |
| `Guide.md` | Complete documentation |
| `screenshots/` | UI previews |

📘 Full architecture explanation available in [Guide.md](./Guide.md)

---

# 🚀 Installation

> This configuration is designed primarily for **Debian 13 + KDE Plasma**.

## 1️⃣ Backup Existing Config

```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

---

## 2️⃣ Clone Repository

```bash
git clone https://github.com/yourusername/RECLAIMX.git ~/.config/nvim
```

---

## 3️⃣ Install Dependencies (Debian 13)

```bash
sudo apt update

sudo apt install -y \
neovim \
git \
ripgrep \
fd-find \
nodejs \
npm \
python3 \
gcc \
g++ \
clang \
curl \
wget \
unzip \
xclip
```

---

## 4️⃣ Install Nerd Font

Recommended:
- JetBrainsMono Nerd Font

Set the font inside your terminal emulator settings.

---

## 5️⃣ Launch Neovim

```bash
nvim
```

Plugins will install automatically.

---

## 6️⃣ Sync Plugins

```vim
:Lazy sync
```

📘 Full installation guide and troubleshooting:
➡️ [Guide.md](./Guide.md)

---

# ⌨️ Important Keymaps

## Leader Key

```text
Space
```

---

## Navigation

| Keymap | Action |
|---|---|
| `<leader>e` | Toggle Explorer |
| `<leader>ff` | Find Files |
| `<leader>fg` | Live Grep |
| `<leader>x` | Close Buffer |
| `<leader>t` | Floating Terminal |

---

## LSP

| Keymap | Action |
|---|---|
| `gd` | Go to Definition |
| `K` | Hover Documentation |
| `<leader>rn` | Rename Symbol |
| `<leader>ca` | Code Actions |

📘 Complete keymap reference:
➡️ [Guide.md](./Guide.md)

---

# 🔌 Main Plugins

<div align="center">

| Category | Main Plugins |
|---|---|
| 🎨 UI | Catppuccin, Alpha, Lualine |
| 🔍 Navigation | Telescope, Snacks.nvim |
| 🌳 Syntax | Treesitter |
| 🧠 LSP | Mason, nvim-lspconfig |
| 🤖 AI | Copilot, CopilotChat |
| 🌿 Git | Gitsigns, Git Blame |
| 🛠️ Utilities | ToggleTerm, Mini.nvim |

</div>

📘 Full plugin explanations and workflows:
➡️ [Guide.md](./Guide.md)

---

# 🧠 Development Environment

## Included Tooling

- LSP support via Mason
- Auto completion
- Diagnostics
- Formatting on save
- Treesitter parsing
- Git integration
- Floating terminal workflow

---

## Installed LSPs

| LSP | Language |
|---|---|
| `lua_ls` | Lua |
| `ts_ls` | TypeScript / JavaScript |
| `html` | HTML |
| `cssls` | CSS |

📘 Full LSP setup and usage:
➡️ [Guide.md](./Guide.md)

---

# 🎨 UI Experience

Current UI stack includes:

- Catppuccin Mocha
- Transparent windows
- Floating interfaces
- Animated cursor
- Smooth scrolling
- Dashboard startup screen
- Modern statusline
- Buffer tabs

---

# ⚡ Performance

Optimizations include:

- lazy-loaded plugins
- command/event-based loading
- startup profiling
- minimal runtime overhead

Example commands:

```vim
:Lazy
:Lazy profile
:Lazy health
```

📘 Detailed optimization explanation:
➡️ [Guide.md](./Guide.md)

---

# 🛠️ Customization

Basic customization usually happens inside:

```text
lua/plugins/init.lua
```

Examples:
- add plugins
- remove plugins
- change themes
- add LSPs
- modify keymaps

📘 Complete customization guide:
➡️ [Guide.md](./Guide.md)

---

# 📋 Useful Commands

## Lazy.nvim

```vim
:Lazy
:Lazy sync
:Lazy update
:Lazy clean
```

---

## Mason

```vim
:Mason
:MasonInstall
:MasonUpdate
```

---

## Diagnostics

```vim
:checkhealth
:LspInfo
:messages
```

📘 Full command handbook:
➡️ [Guide.md](./Guide.md)

---

# 🧯 Troubleshooting

Common fixes:

```vim
:Lazy sync
:TSUpdate
:LspInfo
:checkhealth
```

📘 Full troubleshooting documentation:
➡️ [Guide.md](./Guide.md)

---

# 🛣️ Roadmap

- [ ] DAP debugging support
- [ ] Session management
- [ ] Test runner integration
- [ ] Better Git workflows
- [ ] More language support
- [ ] Expanded snippet collections
- [ ] Improved project templates

---

# 🐧 Linux Support

This configuration is officially designed for:

- Debian 13
- KDE Plasma

Other Linux distributions may work but are currently untested.

Windows and macOS are NOT officially supported.

---

# 🙏 Credits

Built using:
- Neovim
- Lua
- lazy.nvim
- Treesitter
- Mason
- The Neovim community

---

# 📄 License

This project includes an MIT License.

---

# 📘 Full Documentation

For:
- complete workflows
- plugin explanations
- Vim motions
- advanced concepts
- troubleshooting
- architecture breakdown
- customization tutorials

## ➜ [Open Guide.md](./Guide.md)

---

<div align="center">

### ⚡ Built with Neovim + Lua on Linux

</div>
