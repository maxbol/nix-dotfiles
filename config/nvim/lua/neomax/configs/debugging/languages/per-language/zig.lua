local cache = require("neomax.configs.debugging.cache")
local dap = require("dap")

local env = function()
	local variables = {}
	for k, v in pairs(vim.fn.environ()) do
		table.insert(variables, string.format("%s=%s", k, v))
	end
	return variables
end

local listZigOutExecutables = function()
	return vim.split(vim.fn.glob(vim.fn.getcwd() .. "/zig-out/bin/*"), "\n", { trimempty = true })
end

local function getLastModifiedExecutable()
	local files = listZigOutExecutables()
	local lastModified = 0
	local lastModifiedFile = nil

	for _, file in ipairs(files) do
		local modified = vim.fn.getftime(file)
		if modified > lastModified then
			lastModified = modified
			lastModifiedFile = file
		end
	end

	return lastModifiedFile
end

local selectExecutable = cache.makeProgramSelector("zig", 15)
local selectZigOutExecutable = cache.makeProgramSelector("zig", 15, listZigOutExecutables)

dap.configurations.zig = {
	{
		name = "Debug last modified executable",
		type = "lldb",
		request = "launch",
		program = function()
			local executable = getLastModifiedExecutable()

			if executable ~= nil then
				return executable
			end

			-- Fallback to selection mode
			local co = coroutine.running()
			return coroutine.create(function()
				selectZigOutExecutable(function(val)
					print("Selected file: " .. val)
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
	{
		name = "Debug zig-out executable",
		type = "lldb",
		request = "launch",
		program = function()
			local co = coroutine.running()
			return coroutine.create(function()
				selectZigOutExecutable(function(val)
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
	{
		name = "Debug executable",
		type = "lldb",
		request = "launch",
		program = function()
			local co = coroutine.running()
			return coroutine.create(function()
				selectExecutable(function(val)
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
