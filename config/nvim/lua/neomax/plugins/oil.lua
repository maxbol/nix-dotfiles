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
		require("oil").setup({
			default_file_explorer = true,
			prompt_save_on_select_new_entry = false,
			lsp_file_methods = {
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
			},
		})

		-- Set the local working directory to the current buffer's directory
		-- when working with oil buffers so we can execute shell commands directly
		-- in the oil dir with !cmd
		augroup("OilLocalCwd", { clear = true })
		autocmd("BufEnter", {
			group = "OilLocalCwd",
			callback = function(o)
				if o.match:find("^oil://") then
					vim.cmd("lcd " .. (require("oil").get_current_dir()))
				else
					vim.cmd("lcd " .. (vim.fn.getcwd(-1)))
				end
			end,
		})
	end,
}
