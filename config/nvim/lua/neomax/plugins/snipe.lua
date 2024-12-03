return {
	"leath-dub/snipe.nvim",
	lazy = false,
	keys = {
		{
			"go",
			function()
				require("snipe").open_buffer_menu()
			end,
			desc = "Open Snipe buffer menu",
		},
	},
	opts = {
		ui = {
			max_height = 5,
		},
		sort = "last",
	},
}
