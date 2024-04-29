local js_based_languages = {
	"typescript",
	"javascript",
	"typescriptreact",
	"javascriptreact",
	"vue",
}

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
		-- Debug single nodejs files
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch JS file",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch Current File (pwa-node with ts-node)",
			cwd = vim.fn.getcwd(),
			-- runtimeArgs = {
			-- 	"--loader",
			-- 	"ts-node/esm",
			-- },
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
				VSCODE_DEBUG_MODE = true,
			},
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
			url = function()
				local co = coroutine.running()
				return coroutine.create(function()
					vim.ui.input({
						prompt = "Enter URL: ",
						default = "http://localhost:3000",
					}, function(url)
						if url == nil or url == "" then
							return
						else
							coroutine.resume(co, url)
						end
					end)
				end)
			end,
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
		}, -- Divider for the launch.json derived configs
	}
end
