local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  --------------------------------------------------
  -- 🎨 THEME (PERFECT TRANSPARENCY & TERMINAL)
  --------------------------------------------------
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        transparent_background = true, -- Makes main editor glass/transparent
        integrations = {
          nvimtree = true,
          telescope = { enabled = true },
          notify = true,
          noice = true,
        },
        custom_highlights = function(colors)
          return {
            -- 👈 Forces floating terminal to USE Catppuccin's dark background
            NormalFloat = { bg = colors.mantle },
            FloatBorder = { bg = colors.mantle, fg = colors.mauve },

            -- Ensures your tabline stays transparent
            TabLineFill = { bg = "NONE" },
            TabLine = { bg = "NONE" },
          }
        end
      })

      vim.cmd.colorscheme("catppuccin-mocha")
    end
  },

  --------------------------------------------------
  -- 📝 MARKDOWN LIVE PREVIEW
  --------------------------------------------------
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      -- Optional: makes it so the browser only opens when you tell it to
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
    end,
    ft = { "markdown" },
  },

  --------------------------------------------------
  -- 🌐 LIVE SERVER (HTML/CSS/JS PREVIEW)
  --------------------------------------------------
  {
    "barrett-ruth/live-server.nvim",
    cmd = { "LiveServerStart", "LiveServerStop" },
    init = function()
      -- The new v0.2.0 way to configure options (we'll leave it default)
      -- vim.g.live_server = { port = 8080 }
    end
  },

  --------------------------------------------------
  -- 🌲 FILE TREE
  --------------------------------------------------
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { side = "left", width = 35 },
        renderer = {
          highlight_git = true,
          indent_markers = { enable = true },
        },
      })
    end
  },

  --------------------------------------------------
  -- 🔍 TELESCOPE
  --------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }
  },

  --------------------------------------------------
  -- 🌳 TREESITTER
  --------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local ok, ts = pcall(require, "nvim-treesitter.configs")
      if not ok then return end

      ts.setup({
        ensure_installed = { "lua", "javascript", "html", "css", "typescript" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

  --------------------------------------------------
  -- 📊 STATUSLINE & BUFFERLINE
  --------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = { theme = "auto" }
      })
    end
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup()
    end
  },

  --------------------------------------------------
  -- 💻 FLOAT TERMINAL
  --------------------------------------------------
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        direction = "float",
        shell = "pwsh -NoLogo",
        float_opts = {
          border = "rounded",
          winblend = 0, -- Set to 0 so the Catppuccin background is solid
        },
      })
    end
  },

  --------------------------------------------------
  -- ✨ ANIMATIONS
  --------------------------------------------------
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup()
    end
  },
  {
    "gen740/SmoothCursor.nvim",
    config = function()
      require("smoothcursor").setup({
        type = "default",
        fancy = { enable = true },
      })
    end
  },

  --------------------------------------------------
  -- 🏠 DASHBOARD
  --------------------------------------------------
  {
    "goolord/alpha-nvim",
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
        dashboard.button("f f", "󰈔  Find File", ":Telescope find_files<CR>"),
        dashboard.button("f n", "  New File", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f r", "  Recent Files", ":Telescope oldfiles<CR>"),
        dashboard.button("f g", "󰈭  Find Text", ":Telescope live_grep<CR>"),
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
        val = "🟢 No sessions                      " .. version_str .. "  ",
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
    end
  },

  --------------------------------------------------
  -- 🔔 NOTIFICATIONS
  --------------------------------------------------
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#000000",
        stages = "fade_in_slide_out",
      })
      vim.notify = require("notify")
    end
  },
  {
    "folke/noice.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("noice").setup({
        presets = { command_palette = true, lsp_doc_border = true },
      })
    end
  },

  --------------------------------------------------
  -- 🌿 GIT
  --------------------------------------------------
  { "lewis6991/gitsigns.nvim",                config = true },
  { "f-person/git-blame.nvim",                config = function() vim.g.gitblame_enabled = 1 end },

  --------------------------------------------------
  -- 🚨 INLINE DIAGNOSTICS
  --------------------------------------------------
  { "rachartier/tiny-inline-diagnostic.nvim", config = true },

  --------------------------------------------------
  -- 🧠 LSP (NEOVIM 0.11+ / LSPCONFIG v3.0)
  --------------------------------------------------
  { "williamboman/mason.nvim",                config = true },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "html", "cssls" },
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local cap = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("lua_ls", { capabilities = cap })
      vim.lsp.config("ts_ls", { capabilities = cap })
      vim.lsp.config("html", { capabilities = cap })
      vim.lsp.config("cssls", { capabilities = cap })

      vim.lsp.enable({ "lua_ls", "ts_ls", "html", "cssls" })
    end
  },

  --------------------------------------------------
  -- 🖌️ AUTO-FORMATTER
  --------------------------------------------------
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          typescript = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          json = { "prettier" },
          lua = { "stylua" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },

  --------------------------------------------------
  -- 🤖 AUTOCOMPLETE
  --------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = { { name = "nvim_lsp" } }
      })
    end
  },

})
