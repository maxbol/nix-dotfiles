return {
	"p00f/godbolt.nvim",
	cmd = { "Godbolt", "GodboltCompiler" },
	config = function()
		require("godbolt").setup({
			quickfix = {
				enable = true,
				auto_open = true,
			},
			languages = {
				cpp = { compiler = "g122", options = {} },
				c = { compiler = "cg122", options = {} },
				rust = { compiler = "r1650", options = {} },
				zig = { compiler = "z0140", options = {} },
				odin = { compiler = "odin202501", options = {} },
				go = { compiler = "gl1238", options = {} },
			},
		})
	end,
}
