return {
	-- snippet plugin
	"L3MON4D3/LuaSnip",
	dependencies = "rafamadriz/friendly-snippets",
	opts = { history = true, updateevents = "TextChanged,TextChangedI" },
	config = function(_, opts)
		require("luasnip").config.set_config(opts)
		require("luasnip.loaders.from_vscode").lazy_load()
		require("luasnip").add_snippets("all", {
			require("neomax.configs.snippets.todo"),
		})
	end,
}
