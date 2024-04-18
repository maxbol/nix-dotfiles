return {
	"stevearc/oil.nvim",
	opts = {},
	cmd = "Oil",
	keys = {
		{
			"-",
			"<CMD>Oil<CR>",
			desc = "Open parent directory",
		},
	},
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			keymaps = {
				["<C-v>"] = "actions.select_vsplit",
				["<C-s>"] = false,
			},
		})
	end,
}
