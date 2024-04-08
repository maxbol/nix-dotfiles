return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			-- "vim",
			-- "lua",
			-- "html",
			-- "css",
			-- "javascript",
			-- "typescript",
			-- "tsx",
			-- "c",
			-- "markdown",
			-- "markdown_inline",
			-- "graphql",
			-- "json",
			-- "jsonc",
			-- "go",
			-- "gomod",
		},
		highlight = {
			enable = true,
			use_languagetree = true,
		},
		indent = {
			enable = true,
			-- disable = {
			--   "python"
			-- },
		},
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
}
