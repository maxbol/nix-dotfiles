return {
	"shellRaining/hlchunk.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("hlchunk").setup({
			chunk = {
				enable = true,
				delay = 0,
				-- style = { vim.api.nvim_get_hl(0, { name = "DiagnosticHint" }) },
				use_treesitter = false,
				textobject = "ic",
			},
			indent = {
				enable = true,
			},
			line_num = {
				enable = true,
			},
			blank = {
				enable = true,
			},
		})
	end,
}
