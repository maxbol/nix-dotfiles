return {
	"nvim-neorg/neorg",
	dependencies = { "luarocks.nvim", "folke/zen-mode.nvim" },
	version = "*", -- Pin Neorg to the latest stable release
	config = function()
		require("neorg").setup({
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {},
				["core.dirman"] = {
					config = {
						workspaces = {
							notes = "~/Notes/neorg-notes/",
						},
					},
				},
				["core.presenter"] = {
					config = {
						zen_mode = "zen-mode",
					},
				},
			},
		})
	end,
	ft = { "norg" },
	cmd = { "Neorg" },
}
