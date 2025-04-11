local g = vim.g
local os = require("os")

if g.loaded_lazy_obsession ~= nil then
	return
end

g.loaded_lazy_obsession = true

if g.sessions_root == nil then
	g.sessions_root = vim.fn.stdpath("data") .. "/sessions"
end

local load_session = function()
	local argv = vim.v.argv

	for i, v in ipairs(argv) do
		if v == "-S" then
			-- Neovim was already started with the -S flag,
			-- so there should be no need for us to intervene
			return
		end

		if v == "-c" then
			-- Neovim is started with a special command, probably
			-- to do something very specific. This should not be auto-
			-- handled by obsession
			return
		end

		if v == "+Man!" then
			-- Neovim is being used as a manpager
			return
		end

		if i > 1 and vim.fn.filereadable(v) == 1 then
			-- Neovim was started with a file, so we should not load or start a session
			return
		end
	end

	local session_directory = g.sessions_root .. "/" .. vim.fn.getcwd()
	local session_filename = "Session.vim"
	local session_path = session_directory .. "/" .. session_filename

	if vim.fn.isdirectory(session_directory) == 0 then
		vim.fn.mkdir(session_directory, "p")
	end

	if vim.fn.filereadable(session_path) == 0 then
		vim.cmd("Obsession " .. session_path)
	else
		local ok = pcall(vim.cmd, "source " .. session_path)
		if not ok then
			print("Couldn't fully restore session, clearing session data")
			os.remove(session_path)
			os.remove(session_directory)
		end
	end
end

-- vim.opt.shortmess:append("F")
-- vim.opt.shortmess:append("O")
-- vim.opt.shortmess:append("n")
-- vim.opt.shortmess:append("c")
-- vim.opt.shortmess:append("i")

vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("restore_session", { clear = true }),
	callback = load_session,
	nested = true,
})
