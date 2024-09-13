return {
	{
		"nvim-telescope/telescope.nvim",
		lazy = false,
		config = function()
			require("telescope").setup({
				extensions = {
					recent_files = {
						only_cwd = true,
					},
					-- frecency = {
					-- 	auto_validate = true,
					-- 	db_safe_mode = false,
					-- 	db_validate_treshold = 1,
					-- 	hide_current_buffer = true,
					-- 	matcher = "fuzzy",
					-- },
				},
			})
			-- code
		end,
	},
	{
		"jvgrootveld/telescope-zoxide",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
		},
		lazy = false,
	},
	{
		"smartpde/telescope-recent-files",
		lazy = false,
		config = function()
			-- Load extension.
			require("telescope").load_extension("recent_files")
			-- Map a shortcut to open the picker.
			vim.api.nvim_set_keymap(
				"n",
				"<Leader><Leader>",
				[[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]],
				{ noremap = true, silent = true }
			)
		end,
	},
	-- {
	-- 	"nvim-telescope/telescope-frecency.nvim",
	-- 	config = function()
	-- 		require("telescope").load_extension("frecency")
	-- 	end,
	-- 	dependencies = {
	-- 		"nvim-telescope/telescope.nvim",
	-- 		"nvim-lua/popup.nvim",
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- 	lazy = false,
	-- },
	{
		"nvim-telescope/telescope-dap.nvim",
		config = function()
			require("telescope").load_extension("dap")
		end,
		-- lazy = false,
	},
}
