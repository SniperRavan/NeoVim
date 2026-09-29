# Complete Neovim Guide

> This guide documents this exact configuration from first launch to advanced web development workflows.
> Every keybinding, plugin, and command listed here works directly in this setup.

---

## Table of Contents

1. [What is Neovim?](#1-what-is-neovim)
2. [Beginners: Key Notation, Modes, and `<leader>` Explained](#2-beginners-key-notation-modes-and-leader-explained)
3. [Your Setup at a Glance](#3-your-setup-at-a-glance)
4. [Installation & Requirements](#4-installation--requirements)
5. [First Launch & Startup Flow](#5-first-launch--startup-flow)
6. [The Core Modes](#6-the-core-modes)
7. [Moving Around](#7-moving-around)
8. [Editing & Manipulating Text](#8-editing--manipulating-text)
9. [Saving, Closing, and Sessions](#9-saving-closing-and-sessions)
10. [The File Explorer (Snacks) & Oil](#10-the-file-explorer-snacks--oil)
11. [Search, Fuzzy Finder, and Grug-Far](#11-search-fuzzy-finder-and-grug-far)
12. [Split Windows & Buffer Tabs](#12-split-windows--buffer-tabs)
13. [The Integrated Terminal](#13-the-integrated-terminal)
14. [Language Servers (LSP) & Emmet](#14-language-servers-lsp--emmet)
15. [Autocomplete (Blink.cmp) & Snippets](#15-autocomplete-blinkcmp--snippets)
16. [Formatting (Conform) & Ghost Auto-Save](#16-formatting-conform--ghost-auto-save)
17. [Mason — Package Manager for Tooling](#17-mason--package-manager-for-tooling)
18. [Git Integration](#18-git-integration)
19. [AI Features (Copilot & CopilotChat)](#19-ai-features-copilot--copilotchat)
20. [Web Dev Tools (Live Server, Markdown Preview, Breadcrumbs, Swatches)](#20-web-dev-tools)
21. [Performance & Disabled Built-in Plugins](#21-performance--disabled-built-in-plugins)
22. [Complete Keymap Reference](#22-complete-keymap-reference)
23. [Plugin Manager (Lazy.nvim)](#23-plugin-manager-lazynvim)
24. [Configuration File Structure](#24-configuration-file-structure)
25. [Troubleshooting & Health Checks](#25-troubleshooting--health-checks)
26. [Vim Motions Cheat Sheet](#26-vim-motions-cheat-sheet)

---

## 1. What is Neovim?

Neovim is an extensible, terminal-based modal text editor. Unlike graphical editors (such as VS Code or Sublime Text), you navigate and edit code using modal keyboard sequences.

- **Current Neovim Version:** NVIM v0.12+ (0.11+ required)
- **Theme:** Catppuccin Mocha with transparent background
- **Focus:** Fast, fluid full-stack web development (HTML, CSS, JS, TS, React)

---

## 2. Beginners: Key Notation, Modes, and `<leader>` Explained

If you have never used Vim or Neovim before, key combinations like `<leader>ff` or `map("n", "<C-s>")` can look confusing. Here is exactly what they mean:

### What is the Leader Key (`<leader>`)?
In Vim and Neovim, the **Leader key** is a custom prefix key. It lets you create custom shortcuts without clashing with Vim's default movement letters.
- In this configuration, **`<leader>` is set to the Spacebar (` `)**.
- When this guide says `<leader>ff` or `Space f f`:
  1. Press and release the `Spacebar`.
  2. Press `f`.
  3. Press `f`.
- You do **not** need to hold Space down while pressing the next key.

### Key Notation Cheat Sheet
| Symbol in Config / Guide | What key to physically press | Example |
|---|---|---|
| `<leader>` | **Spacebar** | `<leader>e` = `Space` then `e` |
| `<C-...>` | **Ctrl** key | `<C-s>` = `Ctrl + S`, `<C-n>` = `Ctrl + N`, `<C-/>` = `Ctrl + /` |
| `<S-...>` | **Shift** key | `<S-h>` = `Shift + H` (capital `H`), `<S-F12>` = `Shift + F12` |
| `<A-...>` or `<M-...>` | **Alt** (Meta) key | `<A-j>` = `Alt + J` or `Alt + Down` |
| `<CR>` | **Enter / Return** (`Carriage Return`) | `:w<CR>` = type `:w` and hit Enter |
| `<Esc>` | **Escape** key | Exits current mode back to Normal mode |
| `<Tab>` / `<S-Tab>` | **Tab** / **Shift + Tab** | Next / previous field or suggestion |
| `<BS>` | **Backspace** key | Delete one character to the left |
| `<cmd>...<CR>` | Run an internal command silently without typing on the command line |

### What do Mode Letters Mean? (`"n"`, `"i"`, `"v"`, `"x"`, `"t"`, `"c"`)
Vim uses distinct modes. When key mappings are defined in Lua (e.g. `vim.keymap.set("n", ...)`), the first argument specifies which mode the key works in:
- **`"n"` = Normal Mode:** The default mode. Keys perform navigation, deletion, yanking, or trigger commands. Typing characters here does **not** insert text into the file.
- **`"i"` = Insert Mode:** Regular text-typing mode (like Notepad or VS Code). Press `i` to enter, press `Escape` to leave.
- **`"v"` or `"x"` = Visual Mode:** Text selection mode. Allows you to highlight characters, words, or lines.
- **`"t"` = Terminal Mode:** Active shell terminal inside Neovim.
- **`"c"` = Command Mode:** When you type `:` at the bottom of the screen to run an Ex command.
- **`map({ "n", "i", "x" }, "<C-s>", ...)`:** This means `Ctrl + S` will save your file whether you are currently in Normal mode, typing in Insert mode, or highlighting in Visual mode.

---

## 3. Your Setup at a Glance

| Component | Plugin / Engine | Default Trigger |
|---|---|---|
| Plugin Manager | `lazy.nvim` | `:Lazy` |
| Dashboard | `alpha-nvim` | Automatic on startup |
| File Explorer | `snacks.nvim` explorer | `<leader>e` |
| Alternate File Browser | `oil.nvim` | `-` or `<leader>o` |
| Fuzzy Finder & Grep | `snacks.nvim` picker | `<leader>ff` / `<leader>fg` |
| Search & Replace | `grug-far.nvim` | `<leader>sr` |
| Autocomplete | `blink.cmp` | Automatic as you type |
| Snippets | `LuaSnip` + `friendly-snippets` | `Tab` / `Shift-Tab` |
| Language Servers | `nvim-lspconfig` + `mason` | Automatic on code files |
| Diagnostics & Inline Errors | `tiny-inline-diagnostic` | Virtual inline text |
| Problems Panel | `trouble.nvim` | `<leader>dt` or `<leader>xx` |
| Auto-Formatter | `conform.nvim` | Automatic on save or `<leader>cf` |
| Auto Brackets & Quotes | `mini.pairs` | Automatic on `(`, `[`, `{`, `"`, `'` |
| Move Lines | `mini.move` | `Alt + Up / Down / Left / Right` |
| Auto-close & Rename Tags | `nvim-ts-autotag` | Automatic in HTML/JSX/TSX |
| Color Swatches | `nvim-highlight-colors` | Automatic inline swatches |
| Sticky Scroll | `nvim-treesitter-context` | Pinned function/class headers |
| Breadcrumbs | `dropbar.nvim` | Interactive path/symbol top bar |
| Session Restore | `persistence.nvim` | `<leader>qs` or dashboard `s` button |
| Commenting | `Comment.nvim` | `Ctrl + /` (line) or `<leader>/` (block) |
| Multi-Cursor | `vim-visual-multi` | `Ctrl + n` |
| Bottom Terminal | `toggleterm.nvim` | `<leader>t` or `Ctrl + \`` |
| Git Indicators | `gitsigns.nvim` + `git-blame.nvim` | Sign column + inline blame |
| AI Coding | GitHub Copilot + CopilotChat | `Ctrl + l` accept, `<leader>cc` chat |

---

## 4. Installation & Requirements

### System Requirements
1. **Neovim 0.11+ or 0.12+** is required.
   > **Debian / Ubuntu users:** Run `apt policy neovim`. If the package version is `0.10.x` or older, do not use the distro `apt` package. Download the official release AppImage or tarball from [Neovim Releases](https://github.com/neovim/neovim/releases/latest).
2. **Node.js 20+ or 22+** (required for language servers, GitHub Copilot, and Markdown preview).
3. **JetBrainsMono Nerd Font** (or any modern Nerd Font) set in your terminal emulator.

### 1. Back up existing configuration
```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

### 2. Clone this repository
```bash
git clone https://github.com/SniperRavan/Neovim.git ~/.config/nvim
```

### 3. Install system dependencies
```bash
sudo apt update && sudo apt install -y \
  git ripgrep fd-find nodejs npm \
  python3 gcc g++ clang curl wget unzip xclip
```
> On Wayland desktops, replace `xclip` with `wl-clipboard`.

### 4. Configure Nerd Font
In your terminal configuration (e.g., Alacritty `~/.config/alacritty/alacritty.toml`):
```toml
[font]
normal = { family = "JetBrainsMono Nerd Font", style = "Regular" }
```

### 5. Launch Neovim
```bash
nvim
```
Plugins will synchronize automatically on first run. Once inside, install formatters:
```vim
:MasonInstall prettier stylua
```

---

## 5. First Launch & Startup Flow

When you run `nvim` without specifying a file:
1. `init.lua` enables `vim.loader` byte-compilation for near-instant boot.
2. `core/options.lua`, `core/keymaps.lua`, and `core/autocmds.lua` initialize.
3. `lazy.nvim` initializes plugins.
4. The **Alpha Dashboard** displays centered with quick-action buttons:
   - `f f` → Find project files
   - `f n` → Create blank new file
   - `f r` → Open recent files
   - `f g` → Search text across project
   - `s`   → Restore previous session
   - `f c` → Open Neovim configuration
   - `q`   → Quit Neovim

---

## 6. The Core Modes

### Normal Mode (`NORMAL`)
The standard control mode. Press `Escape` from anywhere to return here.
- Movement keys: `h`, `j`, `k`, `l`, `w`, `b`, `0`, `$`.
- Actions: `d` (delete), `y` (copy), `p` (paste), `u` (undo).

### Insert Mode (`INSERT`)
Typing mode.
- Press `i` to insert before cursor.
- Press `a` to insert after cursor.
- Press `o` to open a new line below and start typing.
- Press `Escape` to return to Normal mode.

### Visual Mode (`VISUAL`, `V-LINE`, `V-BLOCK`)
Selection mode.
- `v`: Character selection.
- `V`: Full line selection.
- `Ctrl + v`: Rectangular column block selection.
- **Shift + Arrow keys:** Works just like VS Code from Normal, Insert, or Visual mode to extend selection.

---

## 7. Moving Around

All navigation is done in **Normal mode**:

### Basic & Word Movement
| Key | Action |
|---|---|
| `h` / `j` / `k` / `l` | Left / Down / Up / Right |
| `w` | Jump forward to start of next word |
| `b` | Jump backward to start of previous word |
| `e` | Jump forward to end of current/next word |
| `0` | Jump to start of line |
| `^` | Jump to first non-whitespace character |
| `$` | Jump to end of line |

### Page & File Movement
| Key | Action |
|---|---|
| `gg` | Jump to the very first line of the file |
| `G` | Jump to the last line of the file |
| `Ctrl + d` | Smooth scroll half-page down (Neoscroll) |
| `Ctrl + u` | Smooth scroll half-page up (Neoscroll) |
| `Ctrl + f` | Page down |
| `Ctrl + b` | Page up |

---

## 8. Editing & Manipulating Text

### Deleting & Changing
| Key | Action |
|---|---|
| `x` | Delete character under cursor |
| `dd` | Delete entire line |
| `diw` | Delete inside current word |
| `ciw` | Change inside word (deletes word and enters Insert mode) |
| `ci"` | Change inside double quotes `""` |
| `ci(` | Change inside parentheses `()` |
| `ci{` | Change inside curly braces `{}` |

### Copying (Yanking) & Pasting
| Key | Action |
|---|---|
| `yy` | Copy current line |
| `yiw` | Copy current word |
| `p` | Paste after cursor |
| `P` | Paste before cursor |
- Neovim is configured with `opt.clipboard = "unnamedplus"`, meaning anything copied with `yy` or `y` is immediately accessible in other system applications via `Ctrl + V`.
- `TextYankPost` only notifies and flashes highlight when text is actually yanked with `y` (not on deletes or cuts).

### Moving Lines (`mini.move`)
Just like in modern IDEs, you can effortlessly slide lines up and down:
- In Normal or Visual mode, press **`Alt + Up`** or **`Alt + Down`** to move the current line or selection.
- Press **`Alt + Left`** or **`Alt + Right`** to adjust indentation.

### Automatic Pairs (`mini.pairs`)
When you type `(`, `[`, `{`, `"`, or `'`, the closing pair is automatically inserted. Deleting the opening character cleanly removes both.

### Multi-Cursor (`vim-visual-multi`)
1. Place cursor on a variable or word.
2. Press **`Ctrl + n`** to select it.
3. Press **`Ctrl + n`** again to find and add cursors to subsequent matches.
4. Type your changes — all cursors edit simultaneously.

### Commenting (`Comment.nvim`)
- Press **`Ctrl + /`** (or `Ctrl + _`) in Normal mode to toggle line comment on the current line.
- In Visual mode, press **`Ctrl + /`** to comment the selected block.
- Press **`<leader>/`** (`Space /`) to toggle block comments (`/* ... */`).
- Fully context-aware: JSX, TSX, HTML `<script>`, and `<style>` tags automatically receive the correct comment syntax.

---

## 9. Saving, Closing, and Sessions

### Saving
- **`Ctrl + s`**: Saves the file silently from Normal, Insert, or Visual mode.
- `:w`: Standard Vim save.

### Safe Quit vs Force Quit
- **`<leader>q` (`Space q`)**: Runs `:qa`. Safe quit that prompts you to save changes if unsaved buffers exist.
- **`<leader>Q` (`Space Q`)**: Runs `:qa!`. Force-quits Neovim immediately, discarding unsaved changes.

### Session Restore (`persistence.nvim`)
- **`<leader>qs`**: Restores the session saved for the current directory.
- **`<leader>ql`**: Restores the last active session.
- **`<leader>qd`**: Disables session saving for the current session.
- You can also hit `s` directly on the Alpha startup dashboard to restore your session.

---

## 10. The File Explorer (Snacks) & Oil

### Snacks Explorer Sidebar
- Toggle the sidebar with **`<leader>e`** (`Space e`).
- Inside the sidebar:
  - `j` / `k`: Move up and down
  - `Enter`: Open file or toggle folder
  - `.`: Toggle hidden dotfiles (`.env`, `.gitignore`)
  - `a`: Add new file
  - `d`: Delete file
  - `r`: Rename file
  - `q`: Close explorer
- Filter configuration automatically excludes `node_modules` and `.git` from cluttering your view while keeping dotfiles visible.

### Oil.nvim (Buffer-based File Manager)
Press **`-`** or **`<leader>o`** to open the parent directory as an editable text buffer:
- Edit file names as plain text.
- Delete lines (`dd`) to delete files.
- Create new lines to create new files.
- Type `:w` to commit your filesystem changes.

---

## 11. Search, Fuzzy Finder, and Grug-Far

### Fuzzy Finding (`snacks.picker`)
- **`<leader>ff`**: Find files in the current project directory (fast, ignores `node_modules`).
- **`<leader>fg`**: Live grep search across text inside project files.
- **`<leader>fr`**: Open recently accessed files.
- **`<leader>fp`**: Command palette (search and execute any Neovim command).
- **`<leader>fb`**: Switch between active buffers.
- **`<leader>fs`**: Jump to LSP symbols in the current file.
- **`<leader>fd`**: Open the diagnostics picker.
- **`<leader>fw`**: Grep the word currently under the cursor across the project.
- **`<leader>fk`**: Search all active keymaps.
- **`<leader>g`**: Global file search across your `$HOME` directory without choking on heavy cache folders.

### Project-wide Search & Replace (`grug-far.nvim`)
- Press **`<leader>sr`** to open the Grug-Far interactive search-and-replace split window.
- Enter your search string, replacement string, and optional file filter. Changes update in real time with visual diffs before you apply them.

---

## 12. Split Windows & Buffer Tabs

### Window Navigation
Window navigation is organized under the `<leader>w` group (or direct `Ctrl + h/j/k/l`) to prevent key delays:
- **`<leader>wh`** / **`<C-h>`**: Focus split to the left
- **`<leader>wj`** / **`<C-j>`**: Focus split below
- **`<leader>wk`** / **`<C-k>`**: Focus split above
- **`<leader>wl`** / **`<C-l>`**: Focus split to the right

### Buffer Tabs (`bufferline.nvim`)
Open files appear as styled tabs along the top:
- **`Shift + l`** (or **`Ctrl + Tab`**, or **`]b`**): Next buffer tab
- **`Shift + h`** (or **`Ctrl + Shift + Tab`**, or **`[b`**): Previous buffer tab
- **`<leader>x`**: Closes the current buffer. If it was the last open file, the Alpha dashboard automatically returns.
- Explorer offset is configured so tabs cleanly start to the right of the sidebar.
- Tabs display live LSP error and warning indicators.

---

## 13. The Integrated Terminal

ToggleTerm provides a VS Code style bottom terminal panel:
- Press **`<leader>t`** or **`Ctrl + \``** to open or hide the terminal panel.
- While inside terminal mode, press **`Ctrl + \``** or **`Ctrl + t`** to immediately hide it. Background jobs (e.g. `npm run dev`) continue running without interruption.
- Press **`Esc Esc`** to enter Normal mode inside the terminal window to scroll through output or copy logs.
- Type `exit` to close the shell session.

---

## 14. Language Servers (LSP) & Emmet

Native `vim.lsp.config` manages language servers with full 0.12+ compatibility:
- `lua_ls`: Lua LSP for configuration editing
- `ts_ls`: TypeScript & JavaScript language server
- `html`: HTML language server
- `cssls`: CSS language server
- `emmet_language_server`: Emmet abbreviations for HTML, JSX, TSX, CSS

### Emmet Fix & Scoping
Emmet is specifically configured for markup and template contexts (`html`, `javascriptreact`, `typescriptreact`, `css`, `scss`, etc.) and excluded from plain JS/TS. This ensures typing standard statements like `console.log` never generates phantom `<console.log>` HTML tags.

### LSP Keybindings
| Shortcut | Action |
|---|---|
| `gd` or `<F12>` | Jump to definition |
| `K` | Hover documentation popup |
| `<S-F12>` or `grr` | Find all references |
| `<leader>rn` or `<F2>` | Rename symbol project-wide |
| `<leader>ca` or `<C-.>` | Quick fix / Code action |
| `<leader>dn` / `<leader>dp` | Next / previous diagnostic error |
| `<leader>dd` | Open diagnostic floating popup |
| `<leader>dt` or `<leader>xx` | Toggle Trouble problems panel |

---

## 15. Autocomplete (Blink.cmp) & Snippets

As you type, Blink.cmp renders a floating completion popup:
- Sources: LSP suggestions, file paths (`./`), LuaSnip templates, and buffer words.
- **`Tab`**: Forward through snippet placeholders or select next suggestion.
- **`Shift + Tab`**: Backward through snippet placeholders or select previous suggestion.
- **`Enter`**: Accept suggestion.
- Documentation preview windows appear automatically after a 200ms delay.

---

## 16. Formatting (Conform) & Ghost Auto-Save

### Ghost Auto-Save
When working on `.html`, `.css`, `.js`, `.jsx`, `.ts`, or `.tsx` files:
- Leaving insert mode or changing text in normal mode silently writes changes using `noautocmd write`.
- **Zero formatting thrashing:** This ensures file changes reach the filesystem for live reloaders without triggering Prettier or re-flowing text while you type.

### Format on Save
- Manual saves (`Ctrl + s` or `:w`) and explicit formatting (**`<leader>cf`**) trigger Conform.
- Formats JavaScript, TypeScript, HTML, CSS, and JSON using Prettier, and Lua using Stylua.
- Configured with a generous 2000ms timeout to avoid timing out on cold starts.

---

## 17. Mason — Package Manager for Tooling

Mason manages external language servers, formatters, and linters:
- **`:Mason`**: Opens the interactive tool manager.
- **`:MasonInstall prettier stylua`**: Installs formatters.
- **`:MasonUpdate`**: Updates the Mason package registry index.

---

## 18. Git Integration

- **Gitsigns:** Colored indicators in the sign column showing modified (`│`), added (`+`), and deleted (`_`) lines.
- **Git-Blame:** Displays the author, date, and commit message inline at the end of the current line. Toggle with `:GitBlameToggle`.

---

## 19. AI Features (Copilot & CopilotChat)

- **Inline Suggestions:** As you type, Copilot displays ghost suggestions. Press **`Ctrl + l`** to accept.
- **CopilotChat (`<leader>cc`):** Opens a floating conversational AI panel.
- **Explain Selection (`<leader>ce`):** Highlights code and prompts Copilot to explain its logic.
- Initial setup: Run `:Copilot auth`.

---

## 20. Web Dev Tools

- **Live Server:** Press **`<leader>ls`** to launch a browser live-server on port 5500. Press **`<leader>lx`** to stop it.
- **Markdown Preview:** Press **`<leader>mp`** to open a real-time rendering browser preview of markdown documents.
- **Breadcrumbs (`dropbar.nvim`):** Displays a clickable, interactive path and code hierarchy bar at the top of the editor.
- **Color Swatches (`nvim-highlight-colors`):** Displays background color highlights on hex codes, rgb values, and Tailwind CSS color classes.
- **Tag Renaming (`nvim-ts-autotag`):** Editing an opening HTML/JSX tag automatically updates its matching closing tag.

---

## 21. Performance & Disabled Built-in Plugins

This setup optimizes startup time via `vim.loader.enable()` and by disabling legacy built-in Vim plugins that are unnecessary for modern development.

### What is disabled in `lua/plugins/init.lua`?
```lua
performance = {
  rtp = {
    disabled_plugins = {
      "gzip",        -- legacy gzip file buffer loader
      "tarPlugin",   -- legacy tar file viewer
      "tohtml",      -- legacy export buffer to HTML
      "zipPlugin",   -- legacy zip file viewer
    },
  },
}
```

### How to re-enable them
If you work with zip or tar archives directly inside Neovim buffers:
1. Open `lua/plugins/init.lua`.
2. Delete or comment out the respective plugin from the `disabled_plugins` table:
   ```lua
   disabled_plugins = {
     "gzip",
     -- "tarPlugin",
     "tohtml",
     -- "zipPlugin",
   },
   ```
3. Save and restart Neovim.

---

## 22. Complete Keymap Reference

| Key Combination | Modes | Description |
|---|---|---|
| `<leader>e` | `n` | Toggle file explorer sidebar |
| `-` or `<leader>o` | `n` | Open directory in Oil |
| `<C-s>` | `n`, `i`, `x` | Save file |
| `<leader>wh/wj/wk/wl` | `n` | Navigate split windows |
| `<C-h/j/k/l>` | `n` | Navigate split windows directly |
| `<S-l>` / `<S-h>` | `n` | Next / previous buffer tab |
| `<C-Tab>` / `<C-S-Tab>` | `n` | Next / previous buffer tab |
| `]b` / `[b` | `n` | Next / previous buffer |
| `<leader>x` | `n` | Close buffer |
| `<leader>q` | `n` | Safe quit Neovim (`:qa`) |
| `<leader>Q` | `n` | Force quit Neovim (`:qa!`) |
| `<leader>ff` | `n` | Find project files |
| `<leader>fg` | `n` | Live grep search |
| `<leader>fr` | `n` | Recent files |
| `<leader>fp` | `n` | Command palette |
| `<leader>fb` | `n` | Buffer switcher |
| `<leader>fs` | `n` | LSP symbols in file |
| `<leader>fd` | `n` | Diagnostics list |
| `<leader>fw` | `n`, `x` | Grep word under cursor |
| `<leader>fk` | `n` | Find active keymaps |
| `<leader>g` | `n` | Global file search ($HOME) |
| `<leader>sr` | `n`, `v` | Project search & replace (Grug-far) |
| `<F2>` | `n` | Rename symbol |
| `<F12>` / `gd` | `n` | Go to definition |
| `<S-F12>` | `n` | Find references |
| `<C-.>` | `n`, `v` | Quick fix / Code action |
| `<leader>cf` | `n` | Format document |
| `<Alt + Up/Down>` | `n`, `v` | Move line or selection up/down |
| `<Ctrl + />` | `n`, `v` | Toggle line comment |
| `<leader>/` | `n`, `v` | Toggle block comment |
| `<Ctrl + n>` | `n` | Start / advance multi-cursor |
| `<leader>t` / `<C-\`>` | `n`, `t` | Toggle bottom terminal |
| `<leader>qs` | `n` | Restore session |
| `<leader>ql` | `n` | Restore last session |
| `<leader>dt` / `<leader>xx` | `n` | Toggle Trouble problems panel |
| `<leader>ls` / `<leader>lx` | `n` | Start / Stop Live Server |
| `<leader>mp` | `n` | Toggle Markdown Preview |
| `<leader>cc` / `<leader>ce` | `n`, `v` | Toggle CopilotChat / Explain code |

---

## 23. Plugin Manager (Lazy.nvim)

- **`:Lazy`**: Opens the visual plugin manager.
- **`:Lazy sync`**: Downloads missing plugins, cleans unused plugins, and updates existing ones.
- **`:Lazy profile`**: Inspects startup times per plugin.
- `lazy-lock.json` pins exact commit hashes for complete cross-machine reproducibility.

---

## 24. Configuration File Structure

```text
~/.config/nvim/
├── init.lua                   ← Entry point, vim.loader
├── lua/
│   ├── core/
│   │   ├── options.lua        ← Editor settings (tabs, numbers, clipboard, scrolloff)
│   │   ├── keymaps.lua        ← All custom shortcuts & VS Code mappings
│   │   └── autocmds.lua       ← UI state machine (Explorer ↔ Alpha, safe ghost-save)
│   └── plugins/
│       ├── init.lua           ← Lazy bootstrap & performance.rtp.disabled_plugins
│       ├── snacks.lua         ← Explorer, Pickers, Notifier, Indent
│       ├── ui.lua             ← Catppuccin, Alpha, Bufferline, Lualine, ToggleTerm, Oil, Trouble, Dropbar, Persistence
│       ├── lsp.lua            ← Mason, LSPConfig, Conform, Blink.cmp, Tiny-inline-diagnostic
│       ├── editor.lua         ← Treesitter, Context, Autotag, Mini, Comment, Grug-Far, Highlight-Colors
│       ├── git.lua            ← Gitsigns, Git-blame
│       ├── ai.lua             ← Copilot, CopilotChat
│       └── snippets.lua       ← LuaSnip, friendly-snippets
```

---

## 25. Troubleshooting & Health Checks

### Check System & Plugin Health
```vim
:checkhealth
:checkhealth vim.lsp
```
Inspects all active language servers, node runtime, clipboard providers, and plugin dependencies.

### Broken Icons or ASCII Art
If icons look like empty rectangles or question marks, ensure your terminal font is configured with **JetBrainsMono Nerd Font**.

### Clipboard Issues
Ensure `xclip` is installed on X11 or `wl-clipboard` is installed on Wayland:
```bash
sudo apt install xclip         # X11
sudo apt install wl-clipboard   # Wayland
```

---

## 26. Vim Motions Cheat Sheet

### Text Objects
Combine with `d` (delete), `c` (change), `y` (copy), `v` (select):
- `iw`: Inner word
- `aw`: Word with surrounding space
- `i"`: Inside double quotes
- `i(`: Inside parentheses
- `i{`: Inside curly brackets
- `ip`: Inner paragraph

### Repetition & Counts
- `5j`: Move down 5 lines
- `3dd`: Delete 3 lines
- `.`: Repeat last change
