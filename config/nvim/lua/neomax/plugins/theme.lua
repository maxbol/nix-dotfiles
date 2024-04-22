return {
	"sainnhe/gruvbox-material",
	priority = 1000,
	lazy = false,
	config = function(_, opts)
		vim.opt.background = "dark" -- dark, light
		vim.g.gruvbox_material_background = "medium" -- hard, medium, soft
		vim.g.gruvbox_material_transparent_background = 1

		vim.cmd([[colorscheme gruvbox-material]])

		vim.cmd([[hi CursorLine guibg=#427b58]])
		vim.cmd([[hi Visual guibg=#427b58]])
		vim.cmd([[hi TelescopeSelection guibg=#427b58]])
		vim.cmd([[hi NotifyBackground guibg=#504945]])
	end,
}
