return {
	"stevearc/dressing.nvim",
	lazy = false,
	config = function()
		require("dressing").setup({
			input = {
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
