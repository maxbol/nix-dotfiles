local cache = require("neomax.configs.debugging.cache")
local dap = require("dap")

local env = function()
	local variables = {}
	for k, v in pairs(vim.fn.environ()) do
		table.insert(variables, string.format("%s=%s", k, v))
	end
	return variables
end

local function selectExecutable(callback)
	local default = cache.getLastDebugCmd("c", vim.fn.getcwd(-1))
	vim.ui.input({ prompt = "Select executable to debug", completion = "file", default = default }, function(cmd)
		if cmd ~= nil then
			cache.storeDebugCmd("c", vim.fn.getcwd(-1), cmd)
		end
		callback(cmd)
	end)
end

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
		env = env,
	},
}
