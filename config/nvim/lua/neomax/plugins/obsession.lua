return {
	{
		"tpope/vim-obsession",
		cond = function()
			return vim.g.neovide == nil
		end,
		lazy = false,
	},
	-- {
	-- 	-- "monokrome/vim-lazy-obsession",
	-- 	-- lazy = false,
	-- },
}
