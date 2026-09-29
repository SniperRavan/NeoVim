return {
  -- Treesitter syntax parsing and queries (main branch for Neovim 0.12+)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      ts.install({
        "lua",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "json",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
        "bash",
      })

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- Sticky scroll: keeps current scope/function header pinned at the top
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      max_lines = 3,
      trim_scope = "outer",
    },
  },

  -- Auto-close and auto-rename HTML / JSX tags
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- Mini.nvim modular utilities (textobjects, surround, icons, pairs, line moving)
  {
    "echasnovski/mini.nvim",
    version = false,
    event = "VeryLazy",
    config = function()
      require("mini.ai").setup()
      require("mini.surround").setup()
      require("mini.icons").setup()
      require("mini.pairs").setup()
      require("mini.move").setup()
    end,
  },

  -- Smooth scrolling animation
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
      require("neoscroll").setup()
    end,
  },

  -- Smooth cursor position trail
  {
    "gen740/SmoothCursor.nvim",
    event = "VeryLazy",
    config = function()
      require("smoothcursor").setup({
        type = "default",
        fancy = { enable = true },
      })
    end,
  },

  -- Multi-cursor editing with Ctrl+n
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = "VeryLazy",
    init = function()
      vim.g.VM_theme = "ocean"
      vim.g.VM_maps = {
        ["Find Under"] = "<C-n>",
      }
    end,
  },

  -- Fast project-wide search and replace panel
  {
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar" },
    opts = {},
  },

  -- CSS color swatches for hex, rgb, and Tailwind classes
  {
    "brenoprata10/nvim-highlight-colors",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      render = "background",
      enable_named_colors = true,
      enable_tailwind = true,
    },
  },

  -- Smart commenting (context-aware for JSX/HTML/JS, Ctrl+/ for line, <leader>/ for block)
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      local ok_ts, ts_context = pcall(require, "ts_context_commentstring")
      if ok_ts then
        ts_context.setup({ enable_autocmd = false })
      end

      local pre_hook = nil
      local ok_hook, ts_hook = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      if ok_hook then
        pre_hook = ts_hook.create_pre_hook()
      end

      require("Comment").setup({
        pre_hook = pre_hook,
      })

      local map = vim.keymap.set
      for _, k in ipairs({ "<C-/>", "<C-_>" }) do
        map("n", k, "<Plug>(comment_toggle_linewise_current)", { desc = "Toggle line comment" })
        map("x", k, "<Plug>(comment_toggle_linewise_visual)", { desc = "Toggle line comment" })
      end
      map("n", "<leader>/", "<Plug>(comment_toggle_blockwise_current)", { desc = "Toggle block comment" })
      map("x", "<leader>/", "<Plug>(comment_toggle_blockwise_visual)", { desc = "Toggle block comment" })
    end,
  },
}
