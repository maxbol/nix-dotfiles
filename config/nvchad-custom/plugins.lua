local overrides = require("custom.configs.overrides")

local js_based_languages = {
	"typescript",
	"javascript",
	"typescriptreact",
	"javascriptreact",
	"vue",
}

---@type NvPluginSpec[]
local plugins = {

	-- Override plugin definition options
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end, -- Override to setup mason-lspconfig
	},

	-- override plugin configs
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},

	-- Install a plugin
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},

	{
		"stevearc/conform.nvim",
		--  for users those who want auto-save conform + lazyloading!
		event = "BufWritePre",
		config = function()
			require("custom.configs.conform")
		end,
	},

	{
		"mfussenegger/nvim-lint",
		event = {
			"BufReadPre",
			"BufWritePre",
		},
		config = function()
			require("custom.configs.nvim-lint")
		end,
	},
	{
		"mfussenegger/nvim-dap",

		dependencies = {

			-- fancy UI for the debugger
			{
				"rcarriga/nvim-dap-ui",
        -- stylua: ignore
        keys = {
          { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
          { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
        },
				opts = {},
				config = function(_, opts)
					-- setup dap config by VsCode launch.json file
					-- require("dap.ext.vscode").load_launchjs()
					local dap = require("dap")
					local dapui = require("dapui")
					dapui.setup(opts)
					dap.listeners.after.event_initialized["dapui_config"] = function()
						dapui.open({})
					end
					dap.listeners.before.event_terminated["dapui_config"] = function()
						dapui.close({})
					end
					dap.listeners.before.event_exited["dapui_config"] = function()
						dapui.close({})
					end
				end,
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
				opts = {
					-- Makes a best effort to setup the various debuggers with
					-- reasonable debug configurations
					automatic_installation = true,

					-- You can provide additional configuration to the handlers,
					-- see mason-nvim-dap README for more information
					-- handlers = {
					-- },

					-- You'll need to check that you have the required things installed
					-- online, please don't ask me how to install them :)
					ensure_installed = {
						-- Update this to ensure that you have the debuggers for the langs you want
						"python",
						"delve",
						"js",
						"bash",
						"elixir",
					},
				},
			},
			-- {
			-- 	"mxsdev/nvim-dap-vscode-js",
			-- 	config = function()
			-- 		---@diagnostic disable-next-line: missing-fields
			-- 		require("dap-vscode-js").setup({
			-- 			debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
			-- 			node_path = os.getenv("HOME") .. "/.nix-profile/bin/node",
			-- 			adapters = {
			-- 				"chrome",
			-- 				"pwa-node",
			-- 				"pwa-chrome",
			-- 				"pwa-msedge",
			-- 				"pwa-extensionHost",
			-- 				"node-terminal",
			-- 				"node",
			-- 			},
			-- 		})
			-- 	end,
			-- },
		},

    -- stylua: ignore
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      -- { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
      {
				"<leader>da",
				function()
					if vim.fn.filereadable(".vscode/launch.json") then
						local dap_vscode = require("dap.ext.vscode")
						dap_vscode.load_launchjs(nil, {
							["node"] = js_based_languages,
							["pwa-node"] = js_based_languages,
							["chrome"] = js_based_languages,
							["pwa-chrome"] = js_based_languages,
						})
					end
					require("dap").continue()
				end,
				desc = "Run with Args",
			},
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },
		config = function()
			require("custom.configs.nvim-dap")
		end,
	},
	-- {
	-- 	"rcarriga/nvim-dap-ui",
	--    -- stylua: ignore
	--    keys = {
	--      { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
	--      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
	--    },
	-- 	opts = {},
	-- 	config = function(_, opts)
	-- 		-- setup dap config by VsCode launch.json file
	-- 		-- require("dap.ext.vscode").load_launchjs()
	-- 		local dap = require("dap")
	-- 		local dapui = require("dapui")
	-- 		dapui.setup(opts)
	-- 		dap.listeners.after.event_initialized["dapui_config"] = function()
	-- 			dapui.open({})
	-- 		end
	-- 		dap.listeners.before.event_terminated["dapui_config"] = function()
	-- 			dapui.close({})
	-- 		end
	-- 		dap.listeners.before.event_exited["dapui_config"] = function()
	-- 			dapui.close({})
	-- 		end
	-- 	end,
	-- },
	-- {
	-- 	"mfussenegger/nvim-dap",
	-- 	config = function()
	-- 		require("custom.configs.nvim-dap")
	-- 	end,
	-- 	keys = {
	-- 		{
	-- 			"<leader>B",
	-- 			function()
	-- 				require("dap").toggle_breakpoint()
	-- 			end,
	-- 		},
	-- 		{
	-- 			"<leader>dO",
	-- 			function()
	-- 				require("dap").step_out()
	-- 			end,
	-- 			desc = "Step Out",
	-- 		},
	-- 		{
	-- 			"<leader>do",
	-- 			function()
	-- 				require("dap").step_over()
	-- 			end,
	-- 			desc = "Step Over",
	-- 		},
	-- 		{
	-- 			"<leader>da",
	-- 			function()
	-- 				if vim.fn.filereadable(".vscode/launch.json") then
	-- 					local dap_vscode = require("dap.ext.vscode")
	-- 					dap_vscode.load_launchjs(nil, {
	-- 						["node"] = js_based_languages,
	-- 						["pwa-node"] = js_based_languages,
	-- 						["chrome"] = js_based_languages,
	-- 						["pwa-chrome"] = js_based_languages,
	-- 					})
	-- 				end
	-- 				require("dap").continue()
	-- 			end,
	-- 			desc = "Run with Args",
	-- 		},
	-- 	},
	-- 	ft = debuggable_fts,
	-- 	dependencies = {
	-- 		-- Install the vscode-js-debug adapter
	-- 		{
	-- 			"microsoft/vscode-js-debug",
	-- 			-- After install, build it and rename the dist directory to out
	-- 			build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
	-- 			version = "1.*",
	-- 		},
	-- 		{
	-- 			"mxsdev/nvim-dap-vscode-js",
	-- 			config = function()
	-- 				---@diagnostic disable-next-line: missing-fields
	-- 				require("dap-vscode-js").setup({
	-- 					-- Path of node executable. Defaults to $NODE_PATH, and then "node"
	-- 					-- node_path = "/home/max/.nix-profile/bin/node",
	--
	-- 					-- Path to vscode-js-debug installation.
	-- 					debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
	--
	-- 					-- Command to use to launch the debug server. Takes precedence over "node_path" and "debugger_path"
	-- 					-- debugger_cmd = { "js-debug-adapter" },
	--
	-- 					-- which adapters to register in nvim-dap
	-- 					adapters = {
	-- 						"chrome",
	-- 						"pwa-node",
	-- 						"pwa-chrome",
	-- 						"pwa-msedge",
	-- 						"pwa-extensionHost",
	-- 						"node-terminal",
	-- 						"node",
	-- 					},
	--
	-- 					-- Path for file logging
	-- 					log_file_path = "~/.cache/nvim/dap_vscode_js.log",
	--
	-- 					-- Logging level for output to file. Set to false to disable logging.
	-- 					-- log_file_level = vim.log.levels.DEBUG,
	--
	-- 					-- Logging level for output to console. Set to false to disable console output.
	-- 					log_console_level = vim.log.levels.DEBUG,
	-- 				})
	-- 			end,
	-- 		},
	-- 		{
	-- 			"Joakker/lua-json5",
	-- 			build = "./install.sh",
	-- 		},
	-- 	},
	-- },
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop " },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", lazy = true, ft = { "sql", "mysql", "plsql" } },
		},
		cmd = { "DBUI", "DBUIFindBuffer" },
	},
	-- To make a plugin not be loaded
	-- {
	--   "NvChad/nvim-colorizer.lua",
	--   enabled = false
	-- },

	-- All NvChad plugins are lazy-loaded by default
	-- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
	-- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
	-- {
	--   "mg979/vim-visual-multi",
	--   lazy = false,
	-- }
}

return plugins
