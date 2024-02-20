return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")

		mason.setup({
			-- horrible hack for NixOS path, please forgive me
			-- PATH = "append",
		})
		mason_lspconfig.setup({
			ensure_installed = {
				"clangd",
				"cmake",
				"lua_ls",
				"pyright",
				"rust_analyzer",
				"texlab",
			},
		})
	end,
}
