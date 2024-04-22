return {
	adapter = function()
		return require("neotest-jest")
	end,
	setup = function(opts)
		opts.disovery = {
			enabled = false,
		}
		return opts
	end,
}
