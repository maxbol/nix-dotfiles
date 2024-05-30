local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd
local g = vim.g
local keymap = vim.keymap

return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", lazy = true, ft = { "sql", "mysql", "plsql" } },
	},
	cmd = { "DBUI", "DBUIFindBuffer", "DBUIToggle" },
	init = function()
		g.completion_chain_complete_list = {
			sql = {
				{ complete_items = { "vim-dadbod-completion" } },
			},
		}
		g.db_ui_use_nerd_fonts = 1
		g.db_ui_execute_on_save = 1
		g.completion_matching_strategy_list = { "exact", "substring" }
		g.completion_matching_ignore_case = 1

		keymap.set("n", "<leader>U", "<CMD>DBUIToggle<CR>", { desc = "Toggle DBUI", buffer = true })
	end,
	keys = {
		{ "<leader>U", mode = "n", desc = "Toggle DBUI" },
	},
	config = function()
		augroup("DadbodCompletions", {})
		autocmd("FileType", {
			pattern = { "sql", "mysql", "plsql" },
			callback = function()
				require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
				keymap.set(
					"n",
					"<leader>R",
					":normal vip<CR><PLUG>(DBUI_ExecuteQuery)",
					{ desc = "Run selected DB query", buffer = true }
				)
				keymap.set(
					{ "x", "o" },
					"<leader>R",
					"<PLUG>(DBUI_ExecuteQuery)",
					{ desc = "Run selected DB query", buffer = true }
				)
				keymap.set("n", "<localleader>F", ":%!sql-formatter-cli .<CR>", { buffer = true })
				keymap.set("n", "<localleader>f", ":normal vip<CR>:!sql-formatter-cli<CR>", { buffer = true })
				keymap.set("n", "<leader>w", "<PLUG>(DBUI_SaveQuery)", { buffer = true })
			end,
		})
	end,
}
