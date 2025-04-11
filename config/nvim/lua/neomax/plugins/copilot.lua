return {
	"github/copilot.vim",
	cmd = "Copilot",
	lazy = false,
	config = function()
		vim.g.copilot_no_tab_map = true
		vim.g.copilot_assume_mapped = true
		vim.g.copilot_tab_fallback = ""
		vim.g.copilot_enabled = false

		-- Enable copilot
		-- vim.cmd([[Copilot enable]])
	end,
}
