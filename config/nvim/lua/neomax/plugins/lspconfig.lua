return {
	"neovim/nvim-lspconfig",
	config = function()
		require("nvchad.configs.lspconfig").defaults()
		require("neomax.configs.lsp")
	end, -- Override to setup mason-lspconfig
}
