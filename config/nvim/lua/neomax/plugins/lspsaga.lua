return {
	"nvimdev/lspsaga.nvim",
	config = function()
		require("lspsaga").setup({
			finder = {
				keys = {
					toggle_or_open = "<CR>",
					quit = "<Esc>",
				},
			},
			diagnostic = {
				keys = {
					quit = { "q", "<ESC>" },
				},
			},
			outline = {
				keys = {
					quit = { "q", "<ESC>" },
					toggle_or_jump = "<CR>",
				},
			},
			rename = {
				auto_save = true,
				in_select = false,
				keys = {
					quit = { "q", "<ESC>" },
					select = "v",
				},
			},
		})
	end,
	event = "LspAttach",
	dependencies = {
		"nvim-treesitter/nvim-treesitter", -- optional
		"nvim-tree/nvim-web-devicons", -- optional
	},
}
