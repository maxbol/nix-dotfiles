local dap = require("dap")

dap.adapters["lldb"] = {
	type = "server",
	name = "lldb",
	port = "${port}",
	executable = {
		command = "/Users/maxbolotin/.nix-profile/bin/lldb-dap",
		args = {
			"-p",
			"${port}",
		},
		options = {
			env = {
				LLDB_DEBUGSERVER_PATH = "/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/Resources/debugserver",
			},
		},
	},
}
