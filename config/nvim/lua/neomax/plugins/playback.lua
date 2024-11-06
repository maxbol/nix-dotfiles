return {
	dir = "~/Source/git-playback.nvim",
	lazy = false,
	config = function()
		vim.api.nvim_create_user_command("Playback", function(o)
			local playback = require("git-playback")
			local filename = vim.fn.expand("%:f")

			local argstr = o.args
			local args = {}
			for arg in argstr:gmatch("%S+") do
				table.insert(args, arg)
			end

			local lhs_diff_commit = args[1]
			local rhs_diff_commit = args[2]

			if not lhs_diff_commit then
				print("Usage: :Playback <lhs-diff-commit> <rhs-diff-commit>")
				return
			end

			playback.playbackFromCommit(lhs_diff_commit, rhs_diff_commit, filename)
		end, { nargs = "*" })
	end,
}
