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
					quit = { "<ESC>" },
				},
			},
			outline = {
				keys = {
					quit = { "<ESC>" },
					toggle_or_jump = "<CR>",
				},
			},
			lightbulb = {
				sign_priority = 5,
			},
			rename = {
				auto_save = true,
				in_select = false,
				keys = {
					quit = { "<ESC>" },
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
