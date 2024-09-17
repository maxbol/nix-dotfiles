return {
	adapter = function()
		return require("neotest-zig")({
			dap = {
				adapter = "lldb",
			},
		})
	end,
}
