return {
	{
		"<leader>tr",
		function()
			require("neotest").run.run()
			require("neotest").summary.open()
		end,
		desc = "Run the nearest test",
	},
	{
		"<leader>tR",
		function()
			require("neotest").run.run(vim.fn.expand("%"))
			require("neotest").summary.open()
		end,
		desc = "Run all tests in file",
	},
	{
		"<leader>td",
		function()
			require("neotest").run.run({ strategy = "dap" })
			require("neotest").summary.open()
		end,
		desc = "Debug the nearest test",
	},
	{
		"<leader>ts",
		function()
			require("neotest").run.stop()
			require("neotest").summary.open()
		end,
		desc = "Stop the nearest test",
	},
	{
		"<leader>ta",
		function()
			require("neotest").run.attach()
			require("neotest").summary.open()
		end,
		desc = "Attach to the nearest test",
	},
	{
		"<leader>to",
		function()
			require("neotest").summary.toggle()
			-- code
		end,
		desc = "Toggle test summary",
	},
	{
		"<leader>tw",
		function()
			require("neotest").watch.toggle()
			require("neotest").summary.open()
			-- code
		end,
		desc = "Toggle watching the nearest test",
	},
	{
		"<leader>tW",
		function()
			require("neotest").watch.toggle(vim.fn.expand("%"))
			require("neotest").summary.open()
			-- code
		end,
		desc = "Toggle watching the current file",
	},
	{
		"[T",
		function()
			require("neotest").jump.prev({ status = "failed" })
			require("neotest").summary.open()
			-- code
		end,
	},
	{
		"]T",
		function()
			require("neotest").jump.next({ status = "failed" })
			require("neotest").summary.open()
			-- code
		end,
	},
	{
		"[t",
		function()
			require("neotest").jump.prev()
			require("neotest").summary.open()
			-- code
		end,
	},
	{
		"]t",
		function()
			require("neotest").jump.next()
			require("neotest").summary.open()
			-- code
		end,
	},
}
