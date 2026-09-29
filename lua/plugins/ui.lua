return {
  -- Catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        integrations = {
          bufferline = true,
          gitsigns = true,
          treesitter = true,
          which_key = true,
          blink_cmp = true,
          mini = { enabled = true },
          snacks = true,
        },
      })
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },

  -- Alpha startup dashboard
  {
    "goolord/alpha-nvim",
    lazy = false,
    priority = 900,
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[                                                                       ]],
        [[       ████ ██████           █████      ██                     ]],
        [[      ███████████             █████                             ]],
        [[      █████████ ███████████████████ ███   ███████████   ]],
        [[     █████████  ███    █████████████ █████ ██████████████   ]],
        [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
        [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
        [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      }

      dashboard.section.buttons.val = {
        dashboard.button("f f", "󰈔  Find File", ":lua Snacks.picker.files()<CR>"),
        dashboard.button("f n", "  New File", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f r", "  Recent Files", ":lua Snacks.picker.recent()<CR>"),
        dashboard.button("f g", "󰈭  Find Text", ":lua Snacks.picker.grep()<CR>"),
        dashboard.button("s", "󰦛  Restore Session", ":lua require('persistence').load()<CR>"),
        dashboard.button("f c", "  Configuration", ":e $MYVIMRC<CR>"),
        dashboard.button("q", "󰩈  Quit", ":qa<CR>"),
      }

      local tagline = {
        type = "text",
        val = "Your ideas, in code.",
        opts = { position = "center", hl = "Comment" },
      }

      local v = vim.version()
      local version_str = "Neovim v" .. v.major .. "." .. v.minor .. "." .. v.patch
      local version_footer = {
        type = "text",
        val = "🟢 Ready                           " .. version_str .. "  ",
        opts = { position = "center", hl = "Comment" },
      }

      dashboard.config.layout = {
        { type = "padding", val = 2 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 2 },
        tagline,
        { type = "padding", val = 1 },
        version_footer,
      }

      alpha.setup(dashboard.opts)
    end,
  },

  -- Bufferline tab bar
  {
    "akinsho/bufferline.nvim",
    dependencies = "echasnovski/mini.icons",
    event = "VeryLazy",
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = true,
          show_close_icon = true,
          offsets = {
            {
              filetype = "snacks_layout_box",
              text = "File Explorer",
              highlight = "Directory",
              separator = true,
            },
          },
          custom_filter = function(buf)
            local ft = vim.bo[buf].filetype
            return ft ~= "alpha" and ft ~= "toggleterm" and not (ft:find("snacks") and ft:find("explorer"))
          end,
        },
      })
    end,
  },

  -- Lualine statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin-mocha",
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- ToggleTerm bottom terminal panel
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec", "ToggleTermToggleAll" },
    event = "VeryLazy",
    config = function()
      require("toggleterm").setup({
        size = 15,
        open_mapping = [[<C-`>]],
        hide_numbers = true,
        shade_terminals = false,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        persist_mode = true,
        direction = "horizontal",
        close_on_exit = true,
        shell = vim.o.shell,
      })
    end,
  },

  -- Oil filesystem editor
  {
    "stevearc/oil.nvim",
    cmd = { "Oil" },
    opts = {
      default_file_explorer = false,
      view_options = {
        show_hidden = true,
      },
    },
  },

  -- Session restoration
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
  },

  -- Diagnostics and problems list panel
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {},
  },

  -- Breadcrumbs navigation bar
  {
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- Markdown live preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_close = 1
    end,
    ft = { "markdown" },
  },

  -- Live Server for web development
  {
    "barrett-ruth/live-server.nvim",
    cmd = { "LiveServerStart", "LiveServerStop" },
    init = function()
      vim.g.live_server_port = 5500
      vim.g.live_server_open_browser = 1
    end,
  },
}
