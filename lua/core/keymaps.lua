local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local pick = function(name, opts)
  return function()
    Snacks.picker[name](opts or {})
  end
end

-- File Explorer & Oil
map("n", "<leader>e", function()
  if _G.ToggleExplorer then
    _G.ToggleExplorer()
  end
end, { desc = "Toggle Sidebar Explorer" })

map("n", "-", "<cmd>Oil<CR>", { desc = "Open Parent Directory (Oil)" })
map("n", "<leader>o", "<cmd>Oil<CR>", { desc = "Open Parent Directory (Oil)" })

-- Project & File Search (Snacks Picker)
map("n", "<leader>ff", pick("files", { cwd = vim.fn.getcwd(), hidden = true, ignored = false }), { desc = "Find Project Files" })
map("n", "<leader>fg", pick("grep", { cwd = vim.fn.getcwd(), hidden = true, ignored = false }), { desc = "Live Grep Project" })
map("n", "<leader>fr", pick("recent"), { desc = "Recent Files" })
map("n", "<leader>fp", pick("commands"), { desc = "Command Palette" })
map("n", "<leader>fb", pick("buffers"), { desc = "Open Buffers" })
map("n", "<leader>fs", pick("lsp_symbols"), { desc = "Symbols in File" })
map("n", "<leader>fd", pick("diagnostics"), { desc = "Diagnostics Picker" })
map({ "n", "x" }, "<leader>fw", pick("grep_word"), { desc = "Grep Word Under Cursor" })
map("n", "<leader>fk", pick("keymaps"), { desc = "Find Keymaps" })

-- Global file search (home directory without indexing huge caches)
map("n", "<leader>g", pick("files", {
  cwd = vim.uv.os_homedir(),
  hidden = false,
  ignored = false,
  layout = { preset = "ivy" },
}), { desc = "Global File Search (Home)" })

-- Project Search and Replace (Grug-far)
map({ "n", "v" }, "<leader>sr", "<cmd>GrugFar<CR>", { desc = "Search and Replace (GrugFar)" })

-- Window Navigation (grouped under <leader>w to prevent delays on <leader>l)
map("n", "<leader>wh", "<C-w>h", { desc = "Focus Window Left" })
map("n", "<leader>wj", "<C-w>j", { desc = "Focus Window Down" })
map("n", "<leader>wk", "<C-w>k", { desc = "Focus Window Up" })
map("n", "<leader>wl", "<C-w>l", { desc = "Focus Window Right" })
map("n", "<C-h>", "<C-w>h", { desc = "Focus Window Left" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus Window Down" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus Window Up" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus Window Right" })

-- Buffer Navigation
map("n", "<S-l>", ":BufferLineCycleNext<CR>", { desc = "Next Buffer Tab" })
map("n", "<S-h>", ":BufferLineCyclePrev<CR>", { desc = "Prev Buffer Tab" })
map("n", "<C-Tab>", ":BufferLineCycleNext<CR>", { desc = "Next Buffer Tab (Ctrl+Tab)" })
map("n", "<C-S-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Prev Buffer Tab (Ctrl+Shift+Tab)" })
map("n", "]b", "<cmd>bnext<CR>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprev<CR>", { desc = "Previous Buffer" })
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close Current Buffer" })

-- VS Code Muscle Memory Shortcuts
map({ "n", "i", "x" }, "<C-s>", "<cmd>silent! update<CR>", { desc = "Save File" })
map("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename Symbol" })
map("n", "<F12>", vim.lsp.buf.definition, { desc = "Go to Definition" })
map("n", "<S-F12>", vim.lsp.buf.references, { desc = "Find References" })
map({ "n", "v" }, "<C-.>", vim.lsp.buf.code_action, { desc = "Quick Fix / Code Action" })
map("n", "<leader>cf", function()
  require("conform").format({ lsp_format = "fallback" })
end, { desc = "Format Document" })

-- Sessions (Persistence)
map("n", "<leader>qs", function()
  require("persistence").load()
end, { desc = "Restore Session" })
map("n", "<leader>ql", function()
  require("persistence").load({ last = true })
end, { desc = "Restore Last Session" })
map("n", "<leader>qd", function()
  require("persistence").stop()
end, { desc = "Don't Save Current Session" })

-- Selection with Shift + Arrow keys
map("n", "<S-Up>", "v<Up>", { desc = "Select Up" })
map("n", "<S-Down>", "v<Down>", { desc = "Select Down" })
map("n", "<S-Left>", "v<Left>", { desc = "Select Left" })
map("n", "<S-Right>", "v<Right>", { desc = "Select Right" })

map("v", "<S-Up>", "<Up>", { desc = "Extend Selection Up" })
map("v", "<S-Down>", "<Down>", { desc = "Extend Selection Down" })
map("v", "<S-Left>", "<Left>", { desc = "Extend Selection Left" })
map("v", "<S-Right>", "<Right>", { desc = "Extend Selection Right" })

map("i", "<S-Up>", "<Esc>v<Up>", { desc = "Select Up" })
map("i", "<S-Down>", "<Esc>v<Down>", { desc = "Select Down" })
map("i", "<S-Left>", "<Esc>v<Left>", { desc = "Select Left" })
map("i", "<S-Right>", "<Esc>v<Right>", { desc = "Select Right" })

-- Terminal (ToggleTerm)
map("n", "<leader>t", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal Panel (Bottom)" })
map("n", "<C-`>", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal Panel (Ctrl+`)" })
map("t", "<C-`>", "<cmd>ToggleTerm<CR>", { desc = "Hide Terminal Panel (Ctrl+`)" })
map("t", "<C-t>", "<cmd>ToggleTerm<CR>", { desc = "Hide Terminal Panel (Ctrl+t)" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit Terminal Mode to Normal Mode" })

-- AI / Copilot Chat
map({ "n", "v" }, "<leader>cc", "<cmd>CopilotChatToggle<CR>", { desc = "Toggle Copilot Chat" })
map({ "n", "v" }, "<leader>ce", "<cmd>CopilotChatExplain<CR>", { desc = "Copilot: Explain Code" })

-- Diagnostics & Problems Panel (Trouble)
map("n", "<leader>dn", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next Diagnostic" })
map("n", "<leader>dp", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Prev Diagnostic" })
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Show Diagnostic Popup" })
map("n", "<leader>dt", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Toggle Problems Panel (Trouble)" })
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Toggle Problems Panel (Trouble)" })

-- Web Dev Tools
map("n", "<leader>mp", ":MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })
map("n", "<leader>ls", ":LiveServerStart<CR>", { desc = "Start Live Server" })
map("n", "<leader>lx", ":LiveServerStop<CR>", { desc = "Stop Live Server" })

-- Quit Neovim (safe by default, force with Shift+Q)
map("n", "<leader>q", "<cmd>qa<CR>", { desc = "Quit Neovim" })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Quit Neovim (Force)" })
