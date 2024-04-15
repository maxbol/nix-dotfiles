return {
	"nvim-tree/nvim-tree.lua",
	cmd = { "NvimTreeToggle", "NvimTreeFocus" },
	opts = {
		view = {
			side = "right",
		},
		git = {
			enable = true,
			ignore = false,
		},
		update_focused_file = {
			enable = true,
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
