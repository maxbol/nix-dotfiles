---@type MappingsTable
local M = {}

M.general = {
	n = {
		[";"] = { ":", "enter command mode", opts = { nowait = true } },

		--  format with conform
		["<leader>fm"] = {
			function()
				require("conform").format()
			end,
			"formatting",
		},
		["gp"] = { "`[v`]", "select pasted text" },
		["<C-d>"] = { "<C-d>zz" },
		["<C-u>"] = { "<C-u>zz" },
		["J"] = { "mzJ`z", "join lines" },
		["N"] = { "Nzzzv", "search previous" },
		["n"] = { "nzzzv", "search next" },
	},
	i = {
		["<PageUp>"] = { "<Esc>" },
	},
	v = {
		[">"] = { ">gv", "indent" },
		["J"] = { ":m '>+1<CR>gv=gv", "move line down" },
		["K"] = { ":m '<-2<CR>gv=gv", "move line up" },
		["<PageUp>"] = { "<Esc>" },
	},
	x = {
		["<leader>p"] = { '"_dP' },
	},
}

M.disabled = {
	n = {
		["<C-h>"] = { "<C-h>", "move to the left window" },
		["<C-j>"] = { "<C-j>", "move to the bottom window" },
		["<C-k>"] = { "<C-k>", "move to the top window" },
		["<C-l>"] = { "<C-l>", "move to the right window" },
	},
}

-- more keybinds!

return M
