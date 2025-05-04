return {
	"natecraddock/workspaces.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"natecraddock/sessions.nvim",
			config = function()
				require("sessions").setup({
					events = { "WinEnter" },
					session_filepath = vim.fn.stdpath("data") .. "/sessions",
					absolute = true,
				})
			end,
		},
		"nvim-telescope/telescope.nvim",
	},
	enabled = true,
	cond = function()
		return vim.g.neovide ~= nil
	end,
	config = function()
		require("workspaces").setup({
			hooks = {
				open_pre = {
					-- If recording, save current session state and stop recording
					"SessionsStop",

					-- delete all buffers (does not save changes)
					"silent %bdelete!",
				},
				open = function()
					local sessions = require("sessions")
					print("Loading session")
					if sessions.load(nil, { silent = true }) == false then
						vim.cmd([[Oil]])
						sessions.start_autosave()
					end
				end,
			},

			require("telescope").load_extension("workspaces"),

			vim.keymap.set({ "n" }, "<C-a><C-o>", "<CMD>Telescope workspaces<CR>", { desc = "List workspaces" }),
		})
	end,
}
