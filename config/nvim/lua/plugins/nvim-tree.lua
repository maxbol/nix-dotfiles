return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local nvimtree = require("nvim-tree")

		-- recommended settings from nvim-tree documentation
		vim.g.loaded = 1
		vim.g.loaded_netrwPlugin = 1

		-- change arrow color
		-- vim.cmd([[ highlight NvimTreeFolderArrowClosed guifg=#D79744 ]])
		-- vim.cmd([[ highlight NvimTreeFolderArrowOpen guifg=#D79744 ]])

		nvimtree.setup({
			renderer = {
				icons = {
					glyphs = {
						folder = {
							arrow_closed = "", -- arrow when folder is closed
							arrow_open = "", -- arrow when folder is open
						},
					},
				},
			},
			filters = { dotfiles = true },
		})

		-- set keymaps
		local keymap = vim.keymap

		keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>")
		keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>")
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>")
	end,
}
