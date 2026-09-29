return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      explorer = {
        enabled = true,
        win = {
          list = {
            keys = {
              ["."] = "toggle_hidden",
            },
          },
        },
      },

      picker = {
        enabled = true,
        sources = {
          explorer = {
            auto_close = false,
            hidden = true,
            ignored = false,
          },
          files = {
            hidden = true,
            ignored = false,
          },
          grep = {
            hidden = true,
            ignored = false,
          },
        },
      },

      notifier = {
        enabled = true,
        timeout = 3000,
        width = { min = 30, max = 80 },
        height = { min = 1, max = 10 },
        margin = { top = 1, right = 1 },
        padding = true,
        sort = { "level", "added" },
        style = "fancy",
        top_down = false,
      },

      indent = {
        enabled = true,
      },

      words = {
        enabled = true,
      },

      zen = {
        enabled = true,
      },
    },

    config = function(_, opts)
      require("snacks").setup(opts)
      vim.notify = require("snacks").notifier.notify
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>f", group = "Find / Picker" },
        { "<leader>l", group = "Live Server" },
        { "<leader>c", group = "Code / Copilot" },
        { "<leader>d", group = "Diagnostics" },
        { "<leader>r", group = "Rename" },
        { "<leader>g", group = "Global Search" },
        { "<leader>m", group = "Markdown" },
        { "<leader>w", group = "Window Splits" },
        { "<leader>s", group = "Search & Replace" },
        { "<leader>q", group = "Session & Quit" },
      },
    },
  },
}
