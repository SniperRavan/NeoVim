local map = vim.keymap.set
vim.g.mapleader = " "

-- Explorer
map("n", "<leader>e", ":NvimTreeToggle<CR>")

-- Search
map("n", "<leader>ff", ":Telescope find_files<CR>")
map("n", "<leader>fg", ":Telescope live_grep<CR>")

-- Navigation
map("n", "<leader>h", "<C-w>h")
map("n", "<leader>l", "<C-w>l")
map("n", "<leader>j", "<C-w>j")
map("n", "<leader>k", "<C-w>k")

-- Buffers
map("n", "<S-l>", ":BufferLineCycleNext<CR>")
map("n", "<S-h>", ":BufferLineCyclePrev<CR>")

-- Terminal (FLOAT)
map("n", "<leader>t", "<cmd>ToggleTerm<CR>")

-- Exit instantly
map("n", "<leader>q", ":qa!<CR>")

--------------------------------------------------
-- 📝 MARKDOWN PREVIEW
--------------------------------------------------
map("n", "<leader>mp", ":MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })

--------------------------------------------------
-- DASHBOARD AUTO OPEN (SPLIT BUG FIXED)
--------------------------------------------------
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      vim.defer_fn(function()
        local ok, alpha = pcall(require, "alpha")
        if ok and vim.api.nvim_buf_is_valid(0) then
          alpha.start()
        end
      end, 100)
    end
  end,
})

--------------------------------------------------
-- 1. OPEN TREE AUTOMATICALLY WHEN A FILE OPENS
--------------------------------------------------
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  callback = function()
    vim.defer_fn(function()
      local ok_tree, api = pcall(require, "nvim-tree.api")
      if ok_tree and not api.tree.is_visible() then
        api.tree.open()
        vim.cmd("wincmd p")
      end
    end, 50)
  end,
})

--------------------------------------------------
-- 2. RETURN TO DASHBOARD WHEN FILES CLOSE
--------------------------------------------------
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function()
    vim.defer_fn(function()
      local bufs = vim.fn.getbufinfo({ buflisted = 1 })
      if #bufs <= 1 then
        local ok, alpha = pcall(require, "alpha")
        if ok then
          alpha.start()
        end
        local ok_tree, api = pcall(require, "nvim-tree.api")
        if ok_tree then
          api.tree.close()
        end
      end
    end, 50)
  end,
})

--------------------------------------------------
-- TERMINAL AUTO STYLE
--------------------------------------------------
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.cmd("startinsert")
    vim.wo.number = false
    vim.wo.relativenumber = false
  end,
})

--------------------------------------------------
-- 🌐 LIVE SERVER SHORTCUTS
--------------------------------------------------
map("n", "<leader>ls", ":LiveServerStart<CR>", { desc = "Start Live Server" })
map("n", "<leader>lx", ":LiveServerStop<CR>", { desc = "Stop Live Server" })

--------------------------------------------------
-- 👻 GHOST AUTO-SAVE (FOR LIVE PREVIEW)
--------------------------------------------------
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  pattern = { "*.html", "*.css", "*.js" },
  callback = function()
    vim.cmd("silent! write")
  end,
})
