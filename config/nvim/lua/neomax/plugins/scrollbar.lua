return {
	"petertriho/nvim-scrollbar",
	lazy = false,
	config = function()
		require("scrollbar").setup({
			handlers = {
				cursor = false,
				search = true,
			},
		})
	end,
	dependencies = {
		{
			"kevinhwang91/nvim-hlslens",
			config = function()
				require("scrollbar.handlers.search").setup()
			end,
		},
	},
}
