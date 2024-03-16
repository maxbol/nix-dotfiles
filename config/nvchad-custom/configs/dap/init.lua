vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
vim.fn.sign_define(
	"DapBreakpoint",
	{ text = "🔴", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
