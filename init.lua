-- Fast byte-compilation loader cache
if vim.loader then
  vim.loader.enable()
end

-- Core editor configuration
require("core.options")
require("core.keymaps")
require("core.autocmds")
require("plugins")
