-- ============================================================
--  plugins/editor.lua
--  Editing experience enhancements:
--  Treesitter, Mini.nvim suite, Neoscroll, SmoothCursor,
--  Visual-multi (multi-cursor)
-- ============================================================

return {

	-- ── Treesitter: proper syntax highlighting ─────────────────
	-- The built-in Neovim syntax highlighting uses regex patterns.
	-- Treesitter actually PARSES your code into a real syntax tree,
	-- giving you much more accurate highlighting, indentation, and
	-- the ability for other plugins to understand code structure.
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate", -- Update parsers after plugin updates
		event = { "BufReadPost", "BufNewFile" }, -- Load when you open any file

		config = function()
			local ok, configs = pcall(require, "nvim-treesitter.configs")
			if not ok then
				return
			end

			configs.setup({
				-- These parsers are automatically installed if missing.
				ensure_installed = {
					"lua",
					"javascript",
					"typescript",
					"html",
					"css",
					"json",
					"vim",
					"vimdoc",
					"markdown",
					"markdown_inline",
					"bash",
				},

				auto_install = true, -- Auto-install parsers for new filetypes you open
				highlight = { enable = true }, -- Turn on Treesitter highlighting
				indent = { enable = true }, -- Turn on Treesitter-based indentation
			})
		end,
	},

	-- ── Mini.nvim: a collection of small focused plugins ───────
	-- We use three modules from the mini.nvim family:
	{
		"echasnovski/mini.nvim",
		version = false,
		event = "VeryLazy",
		config = function()
			-- mini.ai: better text objects
			-- ciw = change inner word (built-in)
			-- cia = change inner "any" — adds function, class, etc. as targets
			-- Example: da) = delete everything inside parentheses including the ()
			require("mini.ai").setup()

			-- mini.surround: add/change/delete surrounding characters
			-- sa" = surround add " around selection
			-- sd" = surround delete "
			-- sr"' = surround replace " with '
			require("mini.surround").setup()

			-- mini.icons: file-type icons used by bufferline, explorer, etc.
			require("mini.icons").setup()
		end,
	},

	-- ── Neoscroll: smooth scrolling ────────────────────────────
	-- Makes Ctrl-d, Ctrl-u, Ctrl-f, Ctrl-b scroll smoothly
	-- instead of jumping instantly.
	{
		"karb94/neoscroll.nvim",
		event = "VeryLazy",
		config = function()
			require("neoscroll").setup()
		end,
	},

	-- ── SmoothCursor: animated cursor trail ────────────────────
	-- The cursor leaves a small animation trail as it moves,
	-- making it easier to track where you are in the file.
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

	-- ── vim-visual-multi: multi-cursor editing ──────────────────
	-- Ctrl-n on a word → select it and find the next occurrence.
	-- Keep pressing Ctrl-n to add more cursors.
	-- Then type normally to edit all selections at once.
	{
		"mg979/vim-visual-multi",
		branch = "master",
		event = "VeryLazy",
		init = function()
			vim.g.VM_theme = "ocean"
			vim.g.VM_maps = {
				["Find Under"] = "<C-n>", -- Ctrl-n to start multi-cursor
			}
		end,
	},

	-- ── Comment.nvim: Smart Multi-line / Single-line commenting ─
	-- Ctrl + / uses block commenting (e.g. /* ... */ in JS/TS/C/Rust/CSS/HTML)
	-- and automatically falls back to single line (# ...) for languages without block comments.
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			local ok_ts_comment, ts_context = pcall(require, "ts_context_commentstring")
			if ok_ts_comment then
				ts_context.setup({
					enable_autocmd = false,
				})
			end

			local ok_comment, comment = pcall(require, "Comment")
			if not ok_comment then
				return
			end

			local ft = require("Comment.ft")

			local pre_hook = nil
			if ok_ts_comment then
				local ok_hook, ts_hook = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
				if ok_hook then
					pre_hook = ts_hook.create_pre_hook()
				end
			end

			comment.setup({
				pre_hook = pre_hook,
			})

			-- Smart toggle helper: uses multi-line/block comments if language supports it,
			-- otherwise falls back cleanly to single-line comments.
			local function smart_toggle_comment(start_row, end_row)
				local ft_name = vim.bo.filetype
				local cstr = ft.get(ft_name)

				local left, right = nil, nil
				local is_block = false

				if type(cstr) == "table" and cstr[2] and cstr[2] ~= "" then
					left, right = cstr[2]:match("^(.-)%%s(.-)$")
					is_block = true
				elseif
					type(cstr) == "string"
					and cstr:find("%%s")
					and not cstr:find("^%s*//")
					and not cstr:find("^%s*#")
				then
					left, right = cstr:match("^(.-)%%s(.-)$")
					is_block = true
				elseif type(cstr) == "table" and cstr[1] then
					left, right = cstr[1]:match("^(.-)%%s(.-)$")
				elseif type(cstr) == "string" then
					left, right = cstr:match("^(.-)%%s(.-)$")
				elseif vim.bo.commentstring ~= "" then
					left, right = vim.bo.commentstring:match("^(.-)%%s(.-)$")
				end

				if not left then
					left = "#"
					right = ""
				end
				right = right or ""

				local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
				if #lines == 0 then
					return
				end

				local function escape_pat(str)
					return str:gsub("([%%%^%$%(%)%%.%[%]%*%+%-%?])", "%%%1")
				end

				local l_esc = escape_pat(left)
				local r_esc = escape_pat(right)

				local is_commented = false
				if is_block and right ~= "" then
					local first_line = lines[1]
					local last_line = lines[#lines]
					local pat = "^%s*" .. l_esc .. "%s*(.-)%s*" .. r_esc .. "%s*$"
					if #lines == 1 then
						is_commented = first_line:match(pat) ~= nil
					else
						is_commented = first_line:match("^%s*" .. l_esc) ~= nil
							and last_line:match(r_esc .. "%s*$") ~= nil
					end
				else
					local pat = "^%s*" .. l_esc
					local all_match = true
					for _, l in ipairs(lines) do
						if l:match("%S") and not l:match(pat) then
							all_match = false
							break
						end
					end
					is_commented = all_match
				end

				if is_commented then
					-- Uncomment
					if is_block and right ~= "" then
						if #lines == 1 then
							local indent, content =
								lines[1]:match("^(%s*)" .. l_esc .. "%s*(.-)%s*" .. r_esc .. "%s*$")
							if indent and content then
								lines[1] = indent .. content
							end
						else
							local indent1, content1 = lines[1]:match("^(%s*)" .. l_esc .. "%s*(.-)$")
							if indent1 and content1 then
								lines[1] = indent1 .. content1
							end
							local contentN = lines[#lines]:match("^(.-)%s*" .. r_esc .. "%s*$")
							if contentN then
								lines[#lines] = contentN
							end
						end
					else
						for i, l in ipairs(lines) do
							local indent, content = l:match("^(%s*)" .. l_esc .. "%s?(.*)$")
							if indent and content then
								lines[i] = indent .. content
							end
						end
					end
				else
					-- Comment
					if is_block and right ~= "" then
						if #lines == 1 then
							local indent, content = lines[1]:match("^(%s*)(.*)$")
							lines[1] = indent .. left .. " " .. content .. " " .. right
						else
							local indent, content = lines[1]:match("^(%s*)(.*)$")
							lines[1] = indent .. left .. " " .. content
							lines[#lines] = lines[#lines] .. " " .. right
						end
					else
						local min_indent = nil
						for _, l in ipairs(lines) do
							if l:match("%S") then
								local ind = l:match("^(%s*)")
								if not min_indent or #ind < #min_indent then
									min_indent = ind
								end
							end
						end
						min_indent = min_indent or ""
						for i, l in ipairs(lines) do
							if l:match("%S") then
								local rest = l:sub(#min_indent + 1)
								lines[i] = min_indent .. left .. " " .. rest
							end
						end
					end
				end

				vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, lines)
			end

			-- Normal mode mappings: Ctrl + / (<C-/> and <C-_>)
			vim.keymap.set("n", "<C-/>", function()
				local row = vim.api.nvim_win_get_cursor(0)[1]
				smart_toggle_comment(row, row)
			end, { desc = "Toggle Block/Line Comment" })
			vim.keymap.set("n", "<C-_>", function()
				local row = vim.api.nvim_win_get_cursor(0)[1]
				smart_toggle_comment(row, row)
			end, { desc = "Toggle Block/Line Comment" })

			-- Visual mode mappings: Ctrl + / (<C-/> and <C-_>)
			vim.keymap.set("v", "<C-/>", function()
				local vstart = vim.fn.getpos("v")[2]
				local vend = vim.fn.getpos(".")[2]
				local start_row = math.min(vstart, vend)
				local end_row = math.max(vstart, vend)
				local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
				vim.api.nvim_feedkeys(esc, "nx", false)
				smart_toggle_comment(start_row, end_row)
			end, { desc = "Toggle Block/Line Comment" })
			vim.keymap.set("v", "<C-_>", function()
				local vstart = vim.fn.getpos("v")[2]
				local vend = vim.fn.getpos(".")[2]
				local start_row = math.min(vstart, vend)
				local end_row = math.max(vstart, vend)
				local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
				vim.api.nvim_feedkeys(esc, "nx", false)
				smart_toggle_comment(start_row, end_row)
			end, { desc = "Toggle Block/Line Comment" })
		end,
	},
}
