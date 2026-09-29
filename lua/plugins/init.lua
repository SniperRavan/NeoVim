-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Load plugin specifications
require("lazy").setup({
  { import = "plugins.snacks" },
  { import = "plugins.ui" },
  { import = "plugins.lsp" },
  { import = "plugins.editor" },
  { import = "plugins.git" },
  { import = "plugins.ai" },
  { import = "plugins.snippets" },
}, {
  rocks = { enabled = false },
  ui = { border = "rounded" },
  performance = {
    rtp = {
      -- Disable built-in Vim plugins not needed in modern development to optimize startup
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "zipPlugin",
      },
    },
  },
})
