local opt = vim.o

return {
	"neovim/nvim-lspconfig",
	event = "User FilePost",
	config = function()
		opt.foldcolumn = "1" -- '0' is not bad
		opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
		opt.foldlevelstart = 99
		require("neomax.configs.lsp")
	end, -- Override to setup mason-lspconfig
	lazy = false,
	dependencies = {
		"kevinhwang91/nvim-ufo",
		"kevinhwang91/promise-async",
		{
			"luukvbaal/statuscol.nvim",
			config = function()
				local builtin = require("statuscol.builtin")
				require("statuscol").setup({
					relculright = true,
					segments = {
						{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },
						{ text = { "%s" }, click = "v:lua.ScSa" },
						{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
					},
				})
			end,
		},
	},
}
