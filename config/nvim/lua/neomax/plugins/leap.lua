return {
	"ggandor/leap.nvim",
	enabled = true,
	keys = {
		{ "s", mode = { "n" }, desc = "Leap Forward to" },
		{ "S", mode = { "n" }, desc = "Leap Backward to" },
		{ "s", mode = { "x", "o" }, desc = "Leap" },
		{ "gs", mode = { "n", "x", "o" }, desc = "Leap from Windows" },
	},
	dependencies = {
		"tpope/vim-repeat",
	},
	config = function(_, opts)
		local leap = require("leap")
		for k, v in pairs(opts) do
			leap.opts[k] = v
		end
		vim.keymap.set({ "n" }, "s", "<Plug>(leap-forward)")
		vim.keymap.set({ "n" }, "S", "<Plug>(leap-backward)")
		vim.keymap.set({ "x", "o" }, "s", "<Plug>(leap)")
		vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)")
		vim.keymap.del({ "x", "o" }, "x")
		vim.keymap.del({ "x", "o" }, "X")
	end,
}
