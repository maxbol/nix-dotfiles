local M = {}

M.langcache = {}

function M.insertIntoList(list, item, maxLength)
	local newList = { item }

	local i = 1
	for _, v in ipairs(list) do
		if i >= maxLength then
			break
		end
		local duplicate = false
		for _, nv in ipairs(newList) do
			if v == nv then
				duplicate = true
				break
			end
		end
		if not duplicate then
			table.insert(newList, v)
			i = i + 1
		end
	end

	return newList
end

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

function M.getDebugCmds(lang, cwd)
	if M.langcache[lang] == nil then
		M.langcache[lang] = {}
	end

	if M.langcache[lang][cwd] ~= nil then
		return M.langcache[lang][cwd]
	end

	local cachePath = M.getCachePath(lang, cwd)
	local cacheFile = cachePath .. "/last-debug-cmd"

	if vim.fn.filereadable(cacheFile) == 0 then
		return {}
	end

	local cmds = vim.fn.readfile(cacheFile)

	M.langcache[lang][cwd] = cmds

	return cmds
end

function M.storeDebugCmds(lang, cwd, cmds)
	if M.langcache[lang] == nil then
		M.langcache[lang] = {}
	end

	local cachePath = M.getCachePath(lang, cwd)
	local cacheFile = cachePath .. "/last-debug-cmd"

	M.langcache[lang][cwd] = cmds
	vim.fn.writefile(cmds, cacheFile)
end

function M.makeProgramSelector(lang, max_no_of_cmds, alt_list_getter)
	return function(callback)
		local cmds = M.getDebugCmds(lang, vim.fn.getcwd(-1))
		local list_cmds = alt_list_getter and alt_list_getter() or cmds
		local default = #list_cmds == 1 and list_cmds[1] or nil
		vim.ui.select(list_cmds, {
			prompt = "Select executable to debug",
			completion = "file",
			default = default,
			include_prompt_in_entries = true,
		}, function(cmd)
			if cmd ~= nil then
				M.storeDebugCmds("c", vim.fn.getcwd(-1), M.insertIntoList(cmds, cmd, max_no_of_cmds))
			end
			callback(cmd)
		end)
	end
end

return M
