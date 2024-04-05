return {
	"David-Kunz/jester",
	keys = {
		{
			"<leader>Tr",
			function()
				require("jester").run()
			end,
		},
		{
			"<leader>TR",
			function()
				require("jester").run_file()
			end,
		},
		{
			"<leader>Tl",
			function()
				require("jester").run_last()
			end,
		},
		{
			"<leader>Td",
			function()
				require("jester").debug()
			end,
		},
		{
			"<leader>TD",
			function()
				require("jester").debug_file()
			end,
		},
		{
			"<leader>TL",
			function()
				require("jester").debug_last()
			end,
		},
	},
	lazy = true,
	opts = {
		dap = { -- debug adapter configuration
			type = "pwa-node",
			request = "launch",
			cwd = vim.fn.getcwd(),
			runtimeExecutable = "ts-node",
			runtimeArgs = { "--inspect-brk", "$path_to_jest", "--no-coverage", "-t", "$result", "--", "$file" },
			args = { "--no-cache" },
			sourceMaps = true,
			protocol = "inspector",
			skipFiles = { "<node_internals>/**/*.js" },
			console = "integratedTerminal",
			port = 9229,
			disableOptimisticBPs = true,
			resolveSourceMapLocations = {
				"${workspaceFolder}/**",
				"!**/node_modules/**",
			},
		},
	},
}
