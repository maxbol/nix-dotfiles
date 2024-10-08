local zig_bleeding_edge_bin = os.getenv("ZIG_BLEEDING_EDGE_BIN")

return {
	adapter = function()
		return require("neotest-zig")({
			dap = {
				adapter = "lldb",
			},
			path_to_zig = zig_bleeding_edge_bin or "zig",
		})
	end,
}
