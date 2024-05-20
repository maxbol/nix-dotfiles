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
		"<F2>",
		function()
			require("dap").continue()
		end,
		desc = "Continue",
	},
	{
		"<F1>",
		function()
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
		"<F4>",
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
		"<F5>",
		function()
			require("dap").step_out()
		end,
		desc = "Step Out",
	},
	{
		"<F3>",
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
			local w = require("dap.ui.widgets")
			w.sidebar(w.sessions, {}, "5 sp").toggle()
		end,
		desc = "Session",
	},
	{
		"<leader>dt",
		function()
			local dap = require("dap")
			local session = dap.session()
			if session and session.parent then
				dap.set_session(session.parent)
			end
			dap.terminate()
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
