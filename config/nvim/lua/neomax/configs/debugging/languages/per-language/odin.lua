local cache = require("neomax.configs.debugging.cache")
local env = require("neomax.configs.debugging.env")
local dap = require("dap")

local selectExecutable = cache.makeProgramSelector("odin", 15)

dap.configurations.odin = {
	{
		name = "Debug test all packages",
		type = "lldb",
		request = "launch",
		runtimeExecutable = "odin",
		args = {
			"test",
			".",
			"-all-packages",
			"-debug",
		},
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		console = "integratedTerminal",
		killBehavior = "polite",
		disableOptimisticBPs = true,
		env = env.default(),
	},
	{
		name = "Debug selected executable",
		type = "lldb",
		request = "launch",
		program = function()
			local co = coroutine.running()
			return coroutine.create(function()
				selectExecutable(function(val)
					if val == nil then
						return
					end
					coroutine.resume(co, val)
				end)
			end)
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},
		console = "integratedTerminal",
		killBehavior = "polite",
		disableOptimisticBPs = true,
		env = env.default(),
	},
}
