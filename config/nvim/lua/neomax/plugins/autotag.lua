return {
	"windwp/nvim-ts-autotag",
	ft = { "html", "vento", "templ" },
	event = "InsertEnter",
	opts = {
		opts = {
			enable_close = true,
			enable_rename = true,
			enable_close_on_slash = false,
		},
		aliases = {
			vento = "html",
		},
	},
	config = function(_, opts)
		require("nvim-ts-autotag").setup(opts)
	end,
}
