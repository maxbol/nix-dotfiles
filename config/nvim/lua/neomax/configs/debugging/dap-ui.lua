return function(_, opts)
	-- setup dap config by VsCode launch.json file
	-- require("dap.ext.vscode").load_launchjs()
	local dap = require("dap")
	local dapui = require("dapui")
	dapui.setup(opts)

	dap.listeners.after.event_continued["dapui_config"] = function()
		dapui.open({})
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close({})
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		print("Dap exited")
		dapui.close({})
	end
end
