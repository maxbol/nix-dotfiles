local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

return {
	"stevearc/oil.nvim",
	lazy = false,
	cmd = "Oil",
	keys = {
		{
			"-",
			"<CMD>Oil<CR>",
			desc = "Open parent directory",
		},
	},
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function(opts)
		local oil = require("oil")

		oil.setup({
			default_file_explorer = true,
			prompt_save_on_select_new_entry = false,
			lsp_file_methods = {
				enabled = true,
				autosave_changes = "unmodified",
			},
			columns = {
				"icon",
				"size",
				"permissions",
				"mtime",
			},
			win_options = {
				winbar = "%{v:lua.require('oil').get_current_dir()}",
			},
			watch_for_changes = true,
			keymaps = {
				["<C-v>"] = "actions.select_vsplit",
				["<C-b>"] = "actions.select_split",
				["<C-s>"] = false,
				["<C-l>"] = false,
				["<C-h>"] = false,
				["<C-r>"] = "actions.refresh",
				["gy"] = "actions.copy_to_system_clipboard",
				["gp"] = "actions.paste_from_system_clipboard",
				["Q"] = "actions.send_to_qflist",
			},
		})

		-- Set the local working directory to the current buffer's directory
		-- when working with oil buffers so we can execute shell commands directly
		-- in the oil dir with !cmd
		local group = augroup("OilLocalCwd", { clear = true })
		autocmd("BufEnter", {
			group = group,
			callback = function(o)
				if o.match:find("^oil://") then
					vim.cmd("lcd " .. (require("oil").get_current_dir()))
				else
					vim.cmd("lcd " .. (vim.fn.getcwd(-1)))
				end
			end,
		})

		-- Misc user customizations to Oil
		group = augroup("OilUserExt", { clear = true })
		autocmd("BufEnter", {
			group = group,
			pattern = { "oil://*" },
			callback = function(o)
				-- Add binding M-g to enter a command propmt to execute a UNIX command with the file name
				-- as argument
				vim.keymap.set("n", "<M-g>", function()
					local window = vim.fn.bufwinid(o.buf)
					local row = vim.api.nvim_win_get_cursor(window)[1]
					local entry = oil.get_entry_on_line(o.buf, row)
					if not entry then
						return
					end

					local name_len = #entry.name

					vim.api.nvim_input(":! " .. entry.name)
					for _ = 1, name_len + 1, 1 do
						vim.api.nvim_input("<Left>")
					end
				end, { buffer = o.buf })
			end,
		})
	end,
}
