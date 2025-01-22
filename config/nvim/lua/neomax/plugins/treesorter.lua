return {
	dir = "~/Source/treesorter.nvim",
	cmd = "TSort",
	config = function()
		require("treesorter").setup()
	end,
}
