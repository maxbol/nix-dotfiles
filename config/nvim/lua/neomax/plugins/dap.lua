return {
	"mfussenegger/nvim-dap",

	dependencies = {

		-- fancy UI for the debugger
		{
			"rcarriga/nvim-dap-ui",
			keys = require("neomax.configs.debugging.keys.dap-ui"),
			opts = {},
			config = require("neomax.configs.debugging.dap-ui"),
			dependencies = {
				"nvim-neotest/nvim-nio",
			},
		},

		-- virtual text for the debugger
		{
			"theHamsta/nvim-dap-virtual-text",
			opts = {},
		},

		-- which key integration
		{
			"folke/which-key.nvim",
			optional = true,
			opts = {
				defaults = {
					["<leader>d"] = { name = "+debug" },
				},
			},
		},

		-- mason.nvim integration
		{
			"jay-babu/mason-nvim-dap.nvim",
			dependencies = "mason.nvim",
			cmd = { "DapInstall", "DapUninstall" },
			opts = require("neomax.configs.debugging.languages.auto"),
		},
		"leoluz/nvim-dap-go",

		-- {
		-- 	"nvim-telescope/telescope-dap.nvim",
		-- 	config = function()
		-- 		require("telescope").load_extension("dap")
		-- 	end,
		-- },
	},
	keys = require("neomax.configs.debugging.keys.dap"),
	config = function()
		require("neomax.configs.debugging.init")
	end,
}
