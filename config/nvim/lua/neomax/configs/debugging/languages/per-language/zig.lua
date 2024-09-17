local dap = require("dap")

local env = function()
	local variables = {}
	for k, v in pairs(vim.fn.environ()) do
		table.insert(variables, string.format("%s=%s", k, v))
	end
	return variables
end

local listExecutables = function()
	return vim.split(vim.fn.glob(vim.fn.getcwd() .. "/zig-out/bin/*"), "\n", { trimempty = true })
end

local function getLastModifiedExecutable()
	local files = listExecutables()
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

local function selectExecutable(callback)
	local files = listExecutables()
	if #files == 0 then
		print("No executables found, can't debug")
		callback(nil)
	end

	vim.ui.select(files, {
		prompt = "Select executable",
	}, callback)
end

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
				selectExecutable(function(val)
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
		name = "Debug selected executable",
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
