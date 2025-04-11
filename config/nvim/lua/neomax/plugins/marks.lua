return {
	"chentoast/marks.nvim",
	event = "VeryLazy",
	opts = {},
	config = function(opts)
		require("marks").setup(opts)
		vim.keymap.set("n", "m<C-q>", "<cmd>MarksQFListAll<cr>")
		vim.keymap.set("n", "mQ", "<cmd>MarksQFListBuf<cr>")
	end,
}
