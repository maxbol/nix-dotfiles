return {
	adapter = function()
		return require("neotest-vitest")({
			filter_dir = function(name, rel_path, root)
				return name ~= "node_modules"
			end,
		})
	end,
}
