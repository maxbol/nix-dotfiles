return {
	"sainnhe/gruvbox-material",
	priority = 1000,
	lazy = false,
	config = function(_, opts)
		vim.opt.background = "dark" -- dark, light
		vim.g.gruvbox_material_background = "hard" -- hard, medium, soft
		vim.g.gruvbox_material_transparent_background = 1

		-- require("gruvbox-material").setup(opts)
		vim.cmd([[colorscheme gruvbox-material]])
	end,
}
