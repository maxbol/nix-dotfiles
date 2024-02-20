return {
	"rmagatti/auto-session",
	config = function()
		local session = require("auto-session")
		local session_lens = require("auto-session.session-lens")

		session.setup({
			log_level = "error",
			auto_session_suppress_dirs = { "~/", "~/Downloads", "/", "/tmp" },
		})

		local keymap = vim.keymap -- for conciseness
		keymap.set("n", "<leader>ss", session_lens.search_session, {})

		-- override default ugly float color
		vim.cmd([[highlight! link NormalFloat Normal]])
	end,
}
