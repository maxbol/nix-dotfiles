return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {},
	config = function()
		local keymap = vim.keymap -- for conciseness
		local trouble = require("trouble.providers.telescope")
		local telescope = require("telescope")

		telescope.setup({
			defaults = {
				mappings = {
					i = { ["<c-t>"] = trouble.open_with_trouble },
					n = { ["<c-t>"] = trouble.open_with_trouble },
				},
			},
		})

		keymap.set("n", "<leader>tt", function()
			require("trouble").open()
		end)
		keymap.set("n", "<leader>D", function()
			require("trouble").open("workspace_diagnostics")
		end)
		keymap.set("n", "<leader>d", function()
			require("trouble").open("document_diagnostics")
		end)
		keymap.set("n", "<leader>tq", function()
			require("trouble").open("quickfix")
		end)
		keymap.set("n", "<leader>tl", function()
			require("trouble").open("loclist")
		end)
		keymap.set("n", "<leader>tT", function()
			require("trouble").open("lsp_type_definitions")
		end)
		keymap.set("n", "<leader>ti", function()
			require("trouble").open("lsp_implementations")
		end)
		keymap.set("n", "<leader>tr", function()
			require("trouble").open("lsp_references")
		end)
	end,
}
