return {
	"mfussenegger/nvim-lint",
	event = {
		"BufReadPre",
		"BufWritePre",
	},
	config = function()
		require("neomax.configs.lint")
	end,
}
