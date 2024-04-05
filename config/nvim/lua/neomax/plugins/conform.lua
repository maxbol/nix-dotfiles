return {
	"stevearc/conform.nvim",
	--  for users those who want auto-save conform + lazyloading!
	event = "BufWritePre",
	config = function()
		require("neomax.configs.conform")
	end,
}
