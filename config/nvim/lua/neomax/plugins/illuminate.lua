return {
	"RRethy/vim-illuminate",
	config = function()
		require("illuminate").configure({
			under_cursor = false,
			filetypes_denylist = {
				"odin",
			},
		})
		-- code
	end,
	lazy = false,
}
