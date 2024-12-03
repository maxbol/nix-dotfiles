local dap = require("dap")

local env = {}

if vim.fn.has("macunix") then
	env.LLDB_DEBUGSERVER_PATH =
		"/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/Resources/debugserver"
end

dap.adapters["lldb"] = {
	type = "server",
	name = "lldb",
	port = "${port}",
	executable = {
		command = "/Users/maxbolotin/.nix-profile/bin/lldb-vscode",
		args = {
			"-p",
			"${port}",
		},
		options = {
			env = env,
		},
	},
}
