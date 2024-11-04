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
				-- TODO(2024-10-24, Max Bolotin): This only works for Mac OS, and should not be here when
				-- running Neovim on Linux. Fix this!!
				-- Setting this here for Mac OS since that is what I'm using at the moment
				LLDB_DEBUGSERVER_PATH = "/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/Resources/debugserver",
			},
		},
	},
}
