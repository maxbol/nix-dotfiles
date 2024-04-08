return {
	"nvim-tree/nvim-tree.lua",
	cmd = { "NvimTreeToggle", "NvimTreeFocus" },
	opts = {
		git = {
			enable = true,
			ignore = false,
		},

		renderer = {
			highlight_git = true,
			icons = {
				show = {
					git = true,
				},
			},
		},
	},
}
