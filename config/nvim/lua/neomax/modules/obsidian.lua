local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup("NotesStart", { clear = true })
vim.api.nvim_create_user_command("NotesStart", function()
	autocmd("VimEnter", {
		group = "NotesStart",
		callback = function()
			vim.cmd("NoNeckPain")
			-- vim.cmd("NoNeckPainResize 120")
			vim.cmd("ObsidianToday")
		end,
	})
end, { desc = "Start dedicated obsidian session" })
