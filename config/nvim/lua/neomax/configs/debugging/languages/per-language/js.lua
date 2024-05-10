local js_based_languages = {
	"typescript",
	"javascript",
	"typescriptreact",
	"javascriptreact",
	"vue",
}

function promptForValue(prompt, default, parser)
	if parser == nil then
		parser = function(val)
			return val
		end
	end

	local co = coroutine.running()
	return coroutine.create(function()
		vim.ui.input({
			prompt = prompt,
			default = default,
		}, function(val)
			print("Got value: " .. val)
			coroutine.resume(co, parser(val))
		end)
	end)
end

local dap = require("dap")

dap.adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = "js-debug-adapter",
		args = { "${port}" },
	},
}

for _, language in ipairs(js_based_languages) do
	dap.configurations[language] = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch Current File (pwa-node with ts-node)",
			cwd = vim.fn.getcwd(),
			runtimeExecutable = "ts-node",
			args = {
				"${file}",
			},
			sourceMaps = true,
			protocol = "inspector",
			skipFiles = {
				"<node_internals>/**",
				"node_modules/**",
			},
			resolveSourceMapLocations = {
				"${workspaceFolder}/**",
				"!**/node_modules/**",
			},
			env = {
				VSCODE_DEBUG_MODE = "true",
			},
			console = "integratedTerminal",
			killBehavior = "polite",
			disableOptimisticBPs = true,
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch File (pwa-node with ts-node)",
			cwd = vim.fn.getcwd(),
			runtimeExecutable = "ts-node",
			args = promptForValue("Path to file? ", "./src/index.ts", function(val)
				return { val }
			end),
			sourceMaps = true,
			protocol = "inspector",
			skipFiles = {
				"<node_internals>/**",
				"node_modules/**",
			},
			resolveSourceMapLocations = {
				"${workspaceFolder}/**",
				"!**/node_modules/**",
			},
			env = {
				VSCODE_DEBUG_MODE = "true",
			},
			console = "integratedTerminal",
			killBehavior = "polite",
			disableOptimisticBPs = true,
		},
		-- Debug single nodejs files
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch JS file",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			protocol = "inspector",
			skipFiles = {
				"<node_internals>/**",
				"node_modules/**",
			},
			resolveSourceMapLocations = {
				"${workspaceFolder}/**",
				"!**/node_modules/**",
			},
			env = {
				VSCODE_DEBUG_MODE = true,
			},
			console = "integratedTerminal",
		},
		-- Debug nodejs processes (make sure to add --inspect when you run the process)
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach",
			processId = require("dap.utils").pick_process,
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
		},
		-- Debug web applications (client side)
		{
			type = "pwa-chrome",
			request = "launch",
			name = "Launch & Debug Chrome",
			url = promptForValue("URL to open", "http://localhost:3000"),
			webRoot = vim.fn.getcwd(),
			protocol = "inspector",
			sourceMaps = true,
			userDataDir = false,
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Debug Jest Tests",
			-- trace = true, -- include debugger info
			runtimeExecutable = "node",
			runtimeArgs = {
				"./node_modules/jest/bin/jest.js",
				"--runInBand",
			},
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			console = "integratedTerminal",
			internalConsoleOptions = "neverOpen",
			resolveSourceMapLocations = {
				"${workspaceFolder}/**",
				"!**/node_modules/**",
			},
		},
	}
end
