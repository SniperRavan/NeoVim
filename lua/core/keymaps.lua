local map = vim.keymap.set
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 🌲 Snacks Explorer & Oil (Replacing NvimTree)
map("n", "<leader>e", function()
	Snacks.explorer({
		layout = {
			preset = "sidebar",
			position = "left",
			width = 30,
		},
	})
end, { desc = "Sidebar Explorer" })
map("n", "-", "<cmd>Oil<CR>", { desc = "Open Parent Directory (Oil)" })

-- Floating Explorer (<leader>g)
map("n", "<leader>g", function()
	Snacks.picker.files({
		cwd = vim.loop.os_homedir(),
		hidden = true,
		ignored = true,
		layout = {
			preset = "ivy",
		},
	})
end, { desc = "Global File Search" })

-- 🔍 Snacks Picker (Replacing Telescope)
map("n", "<leader>ff", function()
	Snacks.picker.files({
		cwd = vim.fn.getcwd(),
    hidden = true,
    ignored = true,
	})
end, { desc = "Find Project Files" })
map("n", "<leader>fg", function()
	Snacks.picker.grep({
		cwd = vim.fn.getcwd(),
    hidden = true,
    ignored = true.
	})
end, { desc = "Live Grep Project" })
map("n", "<leader>fr", function()
	Snacks.picker.recent()
end, { desc = "Recent Files" })

-- 🪟 Window Navigation
map("n", "<leader>h", "<C-w>h", { desc = "Window Left" })
map("n", "<leader>l", "<C-w>l", { desc = "Window Right" })
map("n", "<leader>j", "<C-w>j", { desc = "Window Down" })
map("n", "<leader>k", "<C-w>k", { desc = "Window Up" })

-- 📑 Buffers & Closing
map("n", "<S-l>", ":BufferLineCycleNext<CR>", { desc = "Next Buffer" })
map("n", "<S-h>", ":BufferLineCyclePrev<CR>", { desc = "Prev Buffer" })
map("n", "<leader>x", ":bdelete<CR>", { desc = "Close Buffer" })
-- map("n", "<C-w>", ":bdelete<CR>", { desc = "Close Current File" })

-- 💻 Terminal (FLOAT)
map("n", "<leader>t", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })

-- 🤖 AI / Copilot Chat
map({ "n", "v" }, "<leader>cc", "<cmd>CopilotChatToggle<CR>", { desc = "Toggle Copilot Chat" })
map({ "n", "v" }, "<leader>ce", "<cmd>CopilotChatExplain<CR>", { desc = "Copilot Explain Code" })

-- 🚪 Exit instantly
map("n", "<leader>q", ":qa!<CR>", { desc = "Quit Neovim" })

--------------------------------------------------
-- 📝 WEB DEV TOOLS
--------------------------------------------------
map("n", "<leader>mp", ":MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })
map("n", "<leader>ls", ":LiveServerStart<CR>", { desc = "Start Live Server" })
map("n", "<leader>lx", ":LiveServerStop<CR>", { desc = "Stop Live Server" })

--------------------------------------------------
-- 💻 TERMINAL AUTO STYLE
--------------------------------------------------
vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.cmd("startinsert")
		vim.wo.number = false
		vim.wo.relativenumber = false
	end,
})

--------------------------------------------------
-- 👻 GHOST AUTO-SAVE (FOR LIVE PREVIEW)
--------------------------------------------------
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
	pattern = { "*.html", "*.css", "*.js" },
	callback = function()
		vim.cmd("silent! write")
	end,
})

--------------------------------------------------
-- Diagnostics
--------------------------------------------------
map("n", "<leader>dn", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
map("n", "<leader>dp", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

