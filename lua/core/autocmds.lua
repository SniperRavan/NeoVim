local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Buffer and window inspection helpers
local function is_alpha(buf)
  return vim.bo[buf].filetype == "alpha"
end

local function is_explorer(buf)
  local ft = vim.bo[buf].filetype
  return ft:find("^snacks") ~= nil
end

local function is_real_file(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return false
  end
  if not vim.bo[buf].buflisted then
    return false
  end
  if vim.bo[buf].buftype ~= "" then
    return false
  end
  if is_alpha(buf) or is_explorer(buf) then
    return false
  end
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" and not vim.bo[buf].modified then
    return false
  end
  return true
end

local function real_file_buf_count()
  local count = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if is_real_file(buf) then
      count = count + 1
    end
  end
  return count
end

local function explorer_is_open()
  local pickers = Snacks.picker.get({ source = "explorer" })
  return #pickers > 0
end

local function open_alpha()
  vim.schedule(function()
    local target_win = nil
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_is_valid(win) then
        local buf = vim.api.nvim_win_get_buf(win)
        if not is_explorer(buf) then
          target_win = win
          break
        end
      end
    end

    if target_win and vim.api.nvim_win_is_valid(target_win) then
      vim.api.nvim_set_current_win(target_win)
    end

    vim.cmd("Alpha")
  end)
end

local function open_explorer()
  Snacks.explorer.open({
    layout = {
      preset = "sidebar",
      position = "left",
      width = 30,
    },
  })
end

local function close_explorer()
  for _, p in ipairs(Snacks.picker.get({ source = "explorer" })) do
    p:close()
  end
end

-- Global explorer toggle used by keymaps.lua (<leader>e)
_G.ToggleExplorer = function()
  if explorer_is_open() then
    close_explorer()
    vim.defer_fn(function()
      if real_file_buf_count() == 0 then
        open_alpha()
      end
    end, 100)
    return
  end

  open_explorer()

  -- Return focus to the active editing window rather than trapping in sidebar
  vim.schedule(function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if not is_explorer(buf) then
        vim.api.nvim_set_current_win(win)
        return
      end
    end
  end)
end

-- Open Alpha dashboard on startup if no file argument was passed
autocmd("VimEnter", {
  group = augroup("AlphaStart", { clear = true }),
  callback = function()
    local argc = vim.fn.argc()
    local is_dir = argc == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1

    if is_dir then
      local target_dir = vim.fn.fnamemodify(vim.fn.argv(0), ":p")
      vim.fn.chdir(target_dir)
      vim.defer_fn(open_alpha, 150)
    elseif argc == 0 then
      vim.defer_fn(open_alpha, 150)
    end
  end,
})

-- When the last real file buffer closes, return to Alpha dashboard
autocmd("BufDelete", {
  group = augroup("AlphaFallback", { clear = true }),
  callback = function()
    vim.defer_fn(function()
      if real_file_buf_count() > 0 then
        return
      end

      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_is_valid(win) then
          local buf = vim.api.nvim_win_get_buf(win)
          if not is_explorer(buf) then
            vim.api.nvim_set_current_win(win)
            if not is_alpha(buf) then
              open_alpha()
            end
            return
          end
        end
      end
    end, 50)
  end,
})

-- Prevent Alpha from cluttering buffer lists
autocmd("FileType", {
  group = augroup("AlphaGuard", { clear = true }),
  pattern = "alpha",
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
  end,
})

-- Disable line numbers and gutter elements in the Alpha dashboard window
autocmd("FileType", {
  group = augroup("AlphaAppearance", { clear = true }),
  pattern = "alpha",
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
    vim.wo.cursorline = false
  end,
})

-- Ensure numbers and gutter are restored in editable buffers
autocmd("BufEnter", {
  group = augroup("RestoreLineNumbers", { clear = true }),
  callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    local bt = vim.bo[ev.buf].buftype
    if ft ~= "alpha" and not ft:find("^snacks") and bt == "" then
      vim.wo.number = true
      vim.wo.relativenumber = true
      vim.wo.signcolumn = "yes"
      vim.wo.cursorline = true
    end
  end,
})

-- Guard alpha redraw against invalid window errors when splits resize
local alpha_patched = false
autocmd("FileType", {
  group = augroup("AlphaPatchRedraw", { clear = true }),
  pattern = "alpha",
  callback = function()
    if alpha_patched then
      return
    end
    vim.defer_fn(function()
      local ok, alpha = pcall(require, "alpha")
      if not ok then
        return
      end

      local original_redraw = alpha.redraw
      alpha.redraw = function()
        if alpha.state and alpha.state.win then
          if not vim.api.nvim_win_is_valid(alpha.state.win) then
            return
          end
        end
        pcall(original_redraw)
      end
      alpha_patched = true
    end, 50)
  end,
})

-- Terminal settings: auto insert mode, no line numbers
autocmd("TermOpen", {
  group = augroup("TermStyle", { clear = true }),
  callback = function()
    vim.cmd("startinsert")
    vim.wo.number = false
    vim.wo.relativenumber = false
  end,
})

-- Flash highlight and notify only on actual yanks (not on delete or change)
autocmd("TextYankPost", {
  group = augroup("YankNotify", { clear = true }),
  callback = function()
    if vim.v.event.operator ~= "y" then
      return
    end
    vim.hl.on_yank({ higroup = "Visual", timeout = 200 })
    local count = #vim.v.event.regcontents
    vim.notify("Yanked " .. count .. " line(s)", vim.log.levels.INFO, { title = "Clipboard" })
  end,
})

-- Ghost auto-save without firing format-on-save autocmds
autocmd({ "TextChanged", "InsertLeave" }, {
  group = augroup("GhostSave", { clear = true }),
  pattern = { "*.html", "*.css", "*.js", "*.jsx", "*.ts", "*.tsx" },
  callback = function(ev)
    if vim.bo[ev.buf].modified and vim.bo[ev.buf].buftype == "" then
      vim.cmd("silent! noautocmd write")
    end
  end,
})
