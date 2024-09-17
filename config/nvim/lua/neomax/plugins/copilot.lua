return {
	"github/copilot.vim",
	cmd = "Copilot",
	lazy = false,
	config = function()
		-- Enable copilot
		vim.cmd([[Copilot enable]])
	end,
}
