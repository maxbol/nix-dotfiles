return {
	{
		"nvim-neotest/neotest",
		lazy = true,
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
			"lawrence-laz/neotest-zig",

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
