return function(_, opts)
	-- setup dap config by VsCode launch.json file
	-- require("dap.ext.vscode").load_launchjs()
	local dap = require("dap")
	local dapui = require("dapui")
	dapui.setup(opts)
	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open({})
	end

	-- Below is uncommented because it caused the jester plugin
	-- to behave strangely, so dap-ui stays open after debugging stops
	-- for now

	-- dap.listeners.before.event_terminated["dapui_config"] = function()
	-- 	dapui.close({})
	-- end
	-- dap.listeners.before.event_exited["dapui_config"] = function()
	-- 	dapui.close({})
	-- end
end
