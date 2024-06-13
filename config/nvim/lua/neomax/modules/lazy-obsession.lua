local g = vim.g

if g.loaded_lazy_obsession ~= nil then
	return
end

g.loaded_lazy_obsession = true

if g.sessions_root == nil then
	g.sessions_root = vim.fn.stdpath("data") .. "/sessions"
end

local load_session = function()
	local argv = vim.v.argv

	for _, v in ipairs(argv) do
		if v == "-S" then
			-- Neovim was already started with the -S flag,
			-- so there should be no need for us to intervene
			return
		end
	end

	local session_directory = g.sessions_root .. "/" .. vim.fn.getcwd()
	local session_filename = "Session.vim"
	local session_path = session_directory .. "/" .. session_filename

	print("Session path: " .. session_path)

	if vim.fn.isdirectory(session_directory) == 0 then
		vim.fn.mkdir(session_directory, "p")
	end

	if vim.fn.filereadable(session_path) == 0 then
		vim.cmd("Obsession " .. session_path)
	else
		vim.cmd("source " .. session_path)
	end
end

vim.api.nvim_create_autocmd("VimEnter", {
	callback = load_session,
})
