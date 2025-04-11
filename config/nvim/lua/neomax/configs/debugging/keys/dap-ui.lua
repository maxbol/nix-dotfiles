return {
	{
		"<leader>du",
		function()
			require("dap-view").toggle({})
		end,
		desc = "Dap UI",
	},
	{
		"<leader>d*",
		function()
			require("dap-view").add_expr()
		end,
		desc = "Eval",
		mode = { "n", "v" },
	},
}
