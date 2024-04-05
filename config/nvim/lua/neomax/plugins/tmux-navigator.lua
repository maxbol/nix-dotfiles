return {
	"christoomey/vim-tmux-navigator",
	cmd = {
		"TmuxNavigateLeft",
		"TmuxNavigateDown",
		"TmuxNavigateUp",
		"TmuxNavigateRight",
		"TmuxNavigatePrevious",
	},
	keys = {
		{ "<C-H>", "<Cmd>TmuxNavigateLeft<CR>", desc = "Tmux Navigate Left" },
		{ "<C-J>", "<Cmd>TmuxNavigateDown<CR>", desc = "Tmux Navigate Down" },
		{ "<C-K>", "<Cmd>TmuxNavigateUp<CR>", desc = "Tmux Navigate Up" },
		{ "<C-L>", "<Cmd>TmuxNavigateRight<CR>", desc = "Tmux Navigate Right" },
		{ "<C-\\>", "<Cmd>TmuxNavigatePrevious<CR>", desc = "Tmux Navigate Previous" },
	},
}
