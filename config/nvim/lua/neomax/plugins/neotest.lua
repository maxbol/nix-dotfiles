return {
	lazy = false,
	"nvim-neotest/neotest",
	dependencies = {
		-- Language support
		-- Go
		"akinsho/neotest-go",
		-- Javascript
		"haydenmeade/neotest-jest",
		"marilari88/neotest-vitest",
		"mfussenegger/nvim-dap",

		-- Core dependencies
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	keys = require("neomax.configs.testing.keys"),
	opts = require("neomax.configs.testing.opts"),
	config = require("neomax.configs.testing.config"),
}
