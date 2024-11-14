local cache = require("neomax.configs.debugging.cache")
local env = require("neomax.configs.debugging.env")
local dap = require("dap")

local selectExecutable = cache.makeProgramSelector("c", 15)

dap.configurations.c = {
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
