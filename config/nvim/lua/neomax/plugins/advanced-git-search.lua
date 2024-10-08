return {
	"aaronhallaert/advanced-git-search.nvim",
	cmd = { "AdvancedGitSearch" },
	config = function()
		require("telescope").setup({
			-- move this to the place where you call the telescope setup function
			extensions = {
				advanced_git_search = {
					telescope_theme = {
						diff_commit_file = "ivy",
						diff_commit_line = "ivy",
						diff_branch_file = "ivy",
						changed_on_branch = "ivy",
					},
					-- See Config
				},
			},
		})

		require("telescope").load_extension("advanced_git_search")
	end,
	dependencies = {
		"nvim-telescope/telescope.nvim",
		-- to show diff splits and open commits in browser
		"tpope/vim-fugitive",
		-- to open commits in browser with fugitive
		"tpope/vim-rhubarb",
		-- optional: to replace the diff from fugitive with diffview.nvim
		-- (fugitive is still needed to open in browser)
		-- "sindrets/diffview.nvim",
	},
}
