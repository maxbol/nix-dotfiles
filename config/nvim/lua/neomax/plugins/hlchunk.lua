return {
	"shellRaining/hlchunk.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("hlchunk").setup({
			chunk = {
				enable = true,
				delay = 0,
				style = { vim.api.nvim_get_hl(0, { name = "HLChunk1" }) },
				use_treesitter = false,
				textobject = "ic",
			},
			indent = {
				enable = true,
			},
			line_num = {
				enable = true,
				style = { vim.api.nvim_get_hl(0, { name = "HLLineNum1" }) },
			},
			blank = {
				enable = true,
			},
		})
	end,
}
