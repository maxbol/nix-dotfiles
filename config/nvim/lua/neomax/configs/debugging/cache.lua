local M = {}

M.langcache = {}

function M.getCachePath(lang, cwd)
	local dapCachePath = vim.fn.stdpath("data") .. "/dap-configuration/" .. lang
	if vim.fn.isdirectory(dapCachePath) == 0 then
		vim.fn.mkdir(dapCachePath, "p")
	end

	local fullPath = dapCachePath .. cwd

	if vim.fn.isdirectory(fullPath) == 0 then
		vim.fn.mkdir(fullPath, "p")
	end

	return fullPath
end

function M.getLastDebugCmd(lang, cwd)
	local cachePath = M.getCachePath(lang, cwd)
	local cacheFile = cachePath .. "/last-debug-cmd"

	if M.langcache[lang] == nil then
		M.langcache[lang] = {}
	end

	if M.langcache[lang][cwd] ~= nil then
		return M.langcache[lang][cwd]
	end

	if vim.fn.filereadable(cacheFile) == 0 then
		return nil
	end

	local cmd = vim.fn.readfile(cacheFile)[1]

	M.langcache[lang][cwd] = cmd

	return cmd
end

function M.storeDebugCmd(lang, cwd, cmd)
	local cachePath = M.getCachePath(lang, cwd)
	local cacheFile = cachePath .. "/last-debug-cmd"

	if M.langcache[lang] == nil then
		M.langcache[lang] = {}
	end

	M.langcache[lang][cwd] = cmd
	vim.fn.writefile({ cmd }, cacheFile)
end

return M
