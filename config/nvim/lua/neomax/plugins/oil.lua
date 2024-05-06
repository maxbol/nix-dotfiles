return {
	"stevearc/oil.nvim",
	lazy = false,
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
	config = function(opts)
		require("oil").setup({
			default_file_explorer = true,
			lsp_file_methods = {
				autosave_changes = "unmodified",
			},
			win_options = {
				winbar = "%{v:lua.require('oil').get_current_dir()}",
			},
			experimental_watch_for_changes = true,
			keymaps = {
				["<C-v>"] = "actions.select_vsplit",
				["<C-b>"] = "actions.select_split",
				["<C-s>"] = false,
				["<C-l>"] = false,
				["<C-h>"] = false,
				["<C-r>"] = "actions.refresh",
			},
		})
	end,
}
