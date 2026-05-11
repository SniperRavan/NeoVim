-- ============================================================
--  NEOVIM — init.lua
--  Entry point. Load order matters: options → keymaps → autocmds → plugins
-- ============================================================

require("core.options")
require("core.keymaps")
require("core.autocmds")
require("plugins")

