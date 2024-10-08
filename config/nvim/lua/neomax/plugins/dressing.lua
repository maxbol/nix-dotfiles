return {
	"stevearc/dressing.nvim",
	lazy = false,
	config = function()
		require("dressing").setup({
			select = {
				backend = { "telescope" },
				telescope = require("telescope.themes").get_ivy(),
			},
			input = {
				start_in_insert = false,
				mappings = {
					n = {
						["<Esc>"] = "Close",
						["<CR>"] = "Confirm",
					},
					i = {
						["<C-c>"] = "Close",
						["<CR>"] = "Confirm",
						["<Up>"] = "HistoryPrev",
						["<Down>"] = "HistoryNext",
					},
				},
			},
			-- options
		})
		-- code
	end,
}
