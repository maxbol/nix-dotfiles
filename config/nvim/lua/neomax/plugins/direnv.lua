return {
	"NotAShelf/direnv.nvim",
	enabled = true,
	cond = function()
		return vim.g.neovide ~= nil
	end,
	lazy = false,
	config = function()
		require("direnv").setup()
	end,
}
