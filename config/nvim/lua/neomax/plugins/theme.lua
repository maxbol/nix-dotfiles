if vim.fn.has("macunix") == 1 then
	return {
		{
			"catppuccin/nvim",
			name = "catppuccin",
			priority = 2000,
			lazy = false,
			config = function()
				vim.cmd([[colorscheme catppuccin]])
				require("catppuccin").setup({
					flavour = "mocha",
					integrations = {
						cmp = true,
						gitsigns = true,
						treesitter = true,
						neotest = true,
						dap = true,
						dap_ui = true,
						octo = true,
						lsp_trouble = true,
						diffview = true,
					},
				})
			end,
		},
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons", { "dokwork/lualine-ex" }, "nvim-lua/lsp-status.nvim" },
			lazy = false,
			config = function()
				require("lualine").setup({
					options = {
						theme = "catppuccin",
					},
					sections = {
						lualine_a = { "mode" },
						lualine_b = { "branch", "diff", "diagnostics" },
						lualine_c = { "filename" },
						lualine_x = {
							"encoding",
							-- "fileformat",
							"filetype",
							-- "require'lsp-status'.status()",

							-- "ex.lsp.all",
						},
						lualine_y = { "progress" },
						lualine_z = { "location" },
					},
				})
			end,
		},
	}
end

return {
	{
		"sainnhe/gruvbox-material",
		priority = 1000,
		lazy = false,
		config = function()
			vim.opt.background = "dark" -- dark, light
			vim.g.gruvbox_material_background = "medium" -- hard, medium, soft
			vim.g.gruvbox_material_transparent_background = 1

			vim.cmd([[colorscheme gruvbox-material]])

			vim.cmd([[hi CursorLine guibg=#427b58]])
			vim.cmd([[hi Visual guibg=#427b58]])
			vim.cmd([[hi TelescopeSelection guibg=#427b58]])
			vim.cmd([[hi NotifyBackground guibg=#504945]])
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		config = function()
			require("lualine").setup({
				options = {
					theme = "gruvbox-material",
				},
			})
		end,
	},
}
