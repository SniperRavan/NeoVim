-- ============================================================
--  plugins/ai.lua
--  AI-assisted coding:
--    Copilot     → inline ghost-text suggestions as you type
--    CopilotChat → chat window for explaining/refactoring code
--
--  Requires: GitHub Copilot subscription + Node.js
--  First-time setup: :Copilot auth
-- ============================================================

return {

	-- ── GitHub Copilot: inline AI completions ──────────────────
	-- As you type, Copilot shows a ghost-text suggestion in grey.
	-- Press Ctrl-l to accept the whole suggestion.
	-- Press Alt-] / Alt-[ to cycle between alternatives.
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter", -- Only load when you enter insert mode
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true, -- Show suggestions automatically (don't wait for trigger key)
					keymap = {
						accept = "<C-l>", -- Ctrl-l → accept the full Copilot suggestion
					},
				},
				panel = { enabled = false }, -- Disable the separate panel (we use Chat instead)
			})
		end,
	},

	-- ── CopilotChat: AI chat window ────────────────────────────
	-- <leader>cc → open a floating chat window.
	-- Select code visually, then <leader>cc to chat about that code.
	-- <leader>ce → asks Copilot to explain the selected code.
	--
	-- Inside the chat window:
	--   Type your question and press Enter to submit.
	--   The AI can read your current file context automatically.
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			"zbirenbaum/copilot.lua",
			"nvim-lua/plenary.nvim", -- Utility library required by CopilotChat
		},
		build = "make tiktoken", -- Compiles the token counter (run once on install)
		cmd = {
			"CopilotChatToggle",
			"CopilotChatExplain",
			"CopilotChatFix",
			"CopilotChatOptimize",
			"CopilotChatTests",
		},
		opts = {
			window = {
				layout = "float", -- Show as a floating window
				width = 0.8, -- 80% of screen width
				height = 0.8, -- 80% of screen height
			},
		},
	},
}
