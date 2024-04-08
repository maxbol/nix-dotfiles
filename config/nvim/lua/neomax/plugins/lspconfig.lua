return {
	"neovim/nvim-lspconfig",
	event = "User FilePost",
	config = function()
		require("neomax.configs.lsp")
	end, -- Override to setup mason-lspconfig
	lazy = false
}
