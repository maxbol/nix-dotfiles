return {
	{
		"<leader>dB",
		function()
			require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end,
		desc = "Breakpoint Condition",
	},
	{
		"<leader>db",
		function()
			require("dap").toggle_breakpoint()
		end,
		desc = "Toggle Breakpoint",
	},
	{
		"<leader>dc",
		function()
			require("dap").continue()
		end,
		desc = "Continue",
	},
	-- { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
	{
		"<leader>da",
		function()
			-- if vim.fn.filereadable(".vscode/launch.json") then
			-- 	local dap_vscode = require("dap.ext.vscode")
			-- 	dap_vscode.load_launchjs(nil, {
			-- 		["node"] = js_based_languages,
			-- 		["pwa-node"] = js_based_languages,
			-- 		["chrome"] = js_based_languages,
			-- 		["pwa-chrome"] = js_based_languages,
			-- 	})
			-- end
			require("dap").continue()
		end,
		desc = "Run with Args",
	},
	{
		"<leader>dC",
		function()
			require("dap").run_to_cursor()
		end,
		desc = "Run to Cursor",
	},
	{
		"<leader>dg",
		function()
			require("dap").goto_()
		end,
		desc = "Go to line (no execute)",
	},
	{
		"<leader>di",
		function()
			require("dap").step_into()
		end,
		desc = "Step Into",
	},
	{
		"<leader>dj",
		function()
			require("dap").down()
		end,
		desc = "Down",
	},
	{
		"<leader>dk",
		function()
			require("dap").up()
		end,
		desc = "Up",
	},
	{
		"<leader>dl",
		function()
			require("dap").run_last()
		end,
		desc = "Run Last",
	},
	{
		"<leader>do",
		function()
			require("dap").step_out()
		end,
		desc = "Step Out",
	},
	{
		"<leader>dO",
		function()
			require("dap").step_over()
		end,
		desc = "Step Over",
	},
	{
		"<leader>dp",
		function()
			require("dap").pause()
		end,
		desc = "Pause",
	},
	{
		"<leader>dr",
		function()
			require("dap").repl.toggle()
		end,
		desc = "Toggle REPL",
	},
	{
		"<leader>ds",
		function()
			require("dap").session()
		end,
		desc = "Session",
	},
	{
		"<leader>dt",
		function()
			require("dap").terminate()
		end,
		desc = "Terminate",
	},
	{
		"<leader>dw",
		function()
			require("dap.ui.widgets").hover()
		end,
		desc = "Widgets",
	},
}
