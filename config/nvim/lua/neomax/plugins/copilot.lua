return {
	"github/copilot.vim",
	cmd = "Copilot",
	lazy = false,
	config = function()
		vim.cmd([[Copilot enable]])
	end,
}
