return {
	{
		lazy = false,
		"nvim-neotest/neotest",
		dependencies = {
			-- Language support
			-- Dotnet
			"Issafalcon/neotest-dotnet",
			-- Go
			"akinsho/neotest-go",
			-- Javascript
			"haydenmeade/neotest-jest",
			"marilari88/neotest-vitest",
			-- Zig
			-- Override with personal fork until PR is merged
			-- "maxbol/neotest-zig",
			{
				dir = "~/Source/neotest-zig",
			},
			-- "lawrence-laz/neotest-zig",

			-- Core dependencies
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		keys = require("neomax.configs.testing.keys"),
		opts = require("neomax.configs.testing.opts"),
		config = require("neomax.configs.testing.config"),
	},
}
