return {
	"oskarrrrrrr/symbols.nvim",
	cmd = {
		"SymbolsToggle",
		"Symbols",
		"SymbolsClose",
	},
	keys = { "<leader>o", desc = "Toggle symbols outline" },
	config = function()
		local r = require("symbols.recipes")
		require("symbols").setup(r.DefaultFilters, r.AsciiSymbols, {
			-- custom settings here
			-- e.g. hide_cursor = false
			sidebar = {
				open_direction = "right",
			},
		})
		vim.keymap.set("n", "<leader>o", "<CMD>SymbolsToggle<CR>")
	end,
}
