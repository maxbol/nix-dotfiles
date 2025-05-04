-- some cool quickfix list experiments
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set
local g = vim.g

local is_tmux = vim.env.TMUX ~= nil

if g.makefile_root == nil then
	g.makefile_root = vim.fn.stdpath("data") .. "/make"
end

local M = {}

M.max_history = 15

function M.insertCmdInList(cmds, cmd)
	local new_cmds = { cmd }
	for i, c in ipairs(cmds) do
		if i >= M.max_history then
			break
		end
		if c ~= cmd then
			table.insert(new_cmds, c)
		end
	end
	return new_cmds
end

function M.getProjectFiles(cwd)
	local dir = g.makefile_root .. "/" .. cwd

	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end

	local makefile = dir .. "/make"
	local runfile = dir .. "/run"
	local lintfile = dir .. "/lint"
	return { makefile = makefile, runfile = runfile, lintfile = lintfile }
end

function M.getLastCmds(defaults, cwd)
	local files = M.getProjectFiles(cwd)
	local makecmd = {}
	local runcmd = {}
	local lintcmd = {}

	if vim.fn.filereadable(files.makefile) == 1 then
		makecmd = vim.fn.readfile(files.makefile)
	end

	if vim.fn.filereadable(files.runfile) == 1 then
		runcmd = vim.fn.readfile(files.runfile)
	end

	if vim.fn.filereadable(files.lintfile) == 1 then
		lintcmd = vim.fn.readfile(files.lintfile)
	end

	if #makecmd == 0 then
		makecmd = { defaults.makecmd }
	end

	if #runcmd == 0 then
		runcmd = { defaults.runcmd }
	end

	if #lintcmd == 0 then
		lintcmd = { defaults.lintcmd }
	end

	return { makecmd = makecmd, runcmd = runcmd, lintcmd = lintcmd }
end

function M.storeLintCmds(cmds, cwd)
	local files = M.getProjectFiles(cwd)
	vim.fn.writefile(cmds, files.lintfile)
end

function M.storeMakeCmds(cmds, cwd)
	local files = M.getProjectFiles(cwd)
	vim.fn.writefile(cmds, files.makefile)
end

function M.storeRunCmds(cmds, cwd)
	local files = M.getProjectFiles(cwd)
	vim.fn.writefile(cmds, files.runfile)
end

function M.getCustomCmd(cmds, cb)
	local default = #cmds == 1 and cmds[1] or nil
	vim.ui.select(cmds, {
		prompt = "Enter command:",
		default = default,
		include_prompt_in_entries = true,
	}, function(cmd_with_args)
		if not cmd_with_args then
			return
		end

		cb(cmd_with_args)
	end)
	-- vim.ui.input({
	-- 	prompt = "Arguments:",
	-- 	completion = "shellcmd",
	-- 	default = cmd,
	-- }, function(cmd_with_args) end)
end

function M.make(statusmsg, makecmd, grepcmd, on_success, on_failure)
	local lines = {}
	local grep_lines = {}
	print(statusmsg .. ": " .. makecmd)

	local function on_output(_, data, _)
		if data then
			for _, value in ipairs(data) do
				if value ~= "" then
					table.insert(lines, value)
				end
			end
		end
	end

	local function on_exit(_, exit_code)
		if #lines > 0 then
			local grep_pipe_cmd = "cat <<EOF " .. grepcmd .. "\n" .. table.concat(lines, "\n") .. "\nEOF"
			local grep_io = assert(io.popen(grep_pipe_cmd, "r"))
			local grep_output = grep_io:read("*a")
			grep_io:close()
			if grep_output ~= nil then
				grep_output = grep_output:gsub("\n$", "")
				if grep_output ~= "" then
					grep_lines = vim.split(grep_output, "\n")
				end
			end
		end

		vim.fn.setqflist({}, " ", {
			title = makecmd,
			lines = grep_lines,
		})

		if #grep_lines > 0 then
			vim.cmd("copen")
			print("Encountered " .. #grep_lines .. " errors, opening quickfix list")
			if on_failure then
				on_failure()
			end
		elseif exit_code ~= 0 then
			-- No greppable error lines, so we can't create a quickfix list. Instead, let's
			-- open a split with a temporary buffer showing the entire cmd output.
			--
			local out_lines = {
				"Make error: " .. makecmd .. " failed with exit code " .. exit_code,
				"Command output:",
				"",
			}

			if #lines == 0 then
				lines = { "The command exited with a non-zero exit code but provided no output" }
			end

			for _, line in ipairs(lines) do
				table.insert(out_lines, line)
			end

			table.insert(out_lines, "")
			table.insert(out_lines, "(Press <CR> to close this buffer...)")

			vim.cmd("10sp")
			vim.cmd("enew")
			vim.cmd("setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap")
			vim.keymap.set("n", "<CR>", ":q<CR>", { buffer = vim.api.nvim_win_get_buf(0) })
			vim.api.nvim_buf_set_lines(0, 0, -1, false, out_lines)
			vim.cmd("cclose")

			print("Encountered non-line enumerated error, opening error buffer")

			if on_failure then
				on_failure()
			end
		else
			vim.cmd("cclose")
			print("OK!")
			if on_success then
				on_success()
			end
		end
		-- vim.cmd("doautocmd QuickFixCmdPost")
	end

	vim.fn.jobstart(makecmd, {
		on_stderr = on_output,
		on_stdout = on_output,
		on_exit = on_exit,
		stdout_buffered = true,
		stderr_buffered = true,
	})
end

function M.run(runcmd, on_success, on_failure)
	local ui = vim.api.nvim_list_uis()[1]

	print("Running project: " .. runcmd)

	local cmd = runcmd

	if is_tmux and ui ~= nil then
		local width = ui.width

		if width > 200 then
			cmd = string.format("tmux split-window -h %s \\; set-option remain-on-exit on", cmd)
		else
			cmd = string.format("tmux new-window %s \\; set-option remain-on-exit on", cmd)
		end
	end

	local success = os.execute(cmd)
	if success and on_success then
		on_success()
	elseif not success and on_failure then
		on_failure()
	end
end

-- TODO(2024-11-10, Max Bolotin): We have managed to set up dressing.nvim to handle a more lazy select,
-- now let's finish our masterpiece by storing a list of up to N historical cmds being run for each type of cmd
-- and feed them into the vim.ui.select
function M.mapMake(o)
	map("n", o.mappingDefault, function()
		M.make(o.label, o.getCmds()[1], o.grepcmd)
	end, { desc = o.descDefault, buffer = o.buffer })
	map("n", o.mappingCustom, function()
		local cmds = o.getCmds()
		M.getCustomCmd(cmds, function(cmd)
			M.make(o.label, cmd, o.grepcmd, o.setCmds(M.insertCmdInList(cmds, cmd)))
		end)
	end, { desc = o.descCustom, buffer = o.buffer })
end

function M.mapMakeRun(o)
	map("n", o.mappingDefault, function()
		M.make(o.label, o.getMakeCmds()[1], o.grepcmd, function()
			local cmd = o.getCmds()[1]
			print("Running project: " .. cmd)
			M.run(cmd)
		end)
	end, { desc = o.descDefault, buffer = o.buffer })
	map("n", o.mappingCustom, function()
		local cmds = o.getCmds()
		M.getCustomCmd(cmds, function(cmd)
			M.make(o.label, o.getMakeCmds()[1], o.grepcmd, function()
				print("Running project: " .. cmd)
				M.run(cmd, o.setCmds(M.insertCmdInList(cmds, cmd)))
			end)
		end)
	end, { desc = o.descCustom, buffer = o.buffer })
end

function M.makeLanguage(opts)
	local makecmd = opts.makecmd
	local runcmd = opts.runcmd
	local lintcmd = opts.lintcmd

	local grepcmds = opts.grepcmds or {
		make = opts.grepcmd,
		lint = opts.grepcmd,
	}

	local cmds_per_cwd = {}

	local function getCmdsByCwd(cwd)
		if cmds_per_cwd[cwd] == nil then
			cmds_per_cwd[cwd] = M.getLastCmds({
				makecmd = makecmd,
				runcmd = runcmd,
				lintcmd = lintcmd,
			}, cwd)
		end
		return cmds_per_cwd[cwd]
	end

	local function getMakeCmds()
		return getCmdsByCwd(vim.fn.getcwd()).makecmd
	end

	local function getRunCmds()
		return getCmdsByCwd(vim.fn.getcwd()).runcmd
	end

	local function getLintCmds()
		return getCmdsByCwd(vim.fn.getcwd()).lintcmd
	end

	local function setMakeCmds(cmds)
		local cwd = vim.fn.getcwd()
		cmds_per_cwd[cwd].makecmd = cmds
		return function()
			M.storeMakeCmds(cmds, cwd)
		end
	end

	local function setRunCmds(cmds)
		local cwd = vim.fn.getcwd()
		cmds_per_cwd[cwd].runcmd = cmds
		return function()
			M.storeRunCmds(cmds, cwd)
		end
	end

	local function setLintCmds(cmds)
		local cwd = vim.fn.getcwd()
		cmds_per_cwd[cwd].lintcmd = cmds
		return function()
			M.storeLintCmd(cmds, cwd)
		end
	end

	local pattern = opts.pattern or { opts.filetype }

	autocmd("Filetype", {
		group = "WorkspaceQuickfix",
		pattern = pattern,
		callback = function(o)
			if lintcmd ~= nil then
				M.mapMake({
					getCmds = getLintCmds,
					setCmds = setLintCmds,
					grepcmd = grepcmds.lint,
					buffer = o.buf,
					descDefault = "Lint project",
					descCustom = "Lint project (custom cmd)",
					mappingDefault = "<leader>yl",
					mappingCustom = "<leader>yL",
					label = "Running linter...",
				})
			end

			if makecmd ~= nil then
				M.mapMake({
					getCmds = getMakeCmds,
					setCmds = setMakeCmds,
					grepcmd = grepcmds.make,
					buffer = o.buf,
					descDefault = "Build project",
					descCustom = "Build project (custom cmd)",
					mappingDefault = "<leader>yb",
					mappingCustom = "<leader>yB",
					label = "Building project...",
				})

				if runcmd ~= nil then
					M.mapMakeRun({
						getCmds = getRunCmds,
						getMakeCmds = getMakeCmds,
						setCmds = setRunCmds,
						grepcmd = grepcmds.make,
						buffer = o.buf,
						descDefault = "Run project",
						descCustom = "Run project (custom cmd)",
						mappingDefault = "<leader>yr",
						mappingCustom = "<leader>yR",
						label = "Building and running project...",
					})
				end
			end
		end,
	})
end

augroup("WorkspaceQuickfix", { clear = true })

M.makeLanguage({
	pattern = { "zig" },
	grepcmd = "2>&1 | grep -E '^.+:[0-9]+:[0-9]+'",
	makecmd = "zig build",
	runcmd = "zig build run",
})

M.makeLanguage({
	pattern = { "odin" },
	grepcmd = "2>&1 | grep -E '^.+\\([0-9]+:[0-9]+\\)' | sed -E 's/\\(([0-9]+:[0-9]+)\\)/:\\1/g'",
	makecmd = "odin build .",
	runcmd = "odin run .",
})

M.makeLanguage({
	pattern = { "go" },
	grepcmds = {
		lint = "2>/dev/null | grep -E '^.+:[0-9]+:[0-9]+'",
		make = "2>&1 | grep -E '^.+:[0-9]+:[0-9]+'",
	},
	lintcmd = "golangci-lint run --timeout 300s --config .golangci.yml ./...",
	makecmd = "go build ./...",
	runcmd = "go run .",
})

M.makeLanguage({
	pattern = { "typescript", "javascript" },
	grepcmds = {
		lint = '2>/dev/null | awk \'/^(\\/.+)$/ { file=$1; } /^\\s*[0-9]+:[0-9]+/ {  errorMsg=""; for (i=3;i<=NF;++i) errorMsg=errorMsg " " $i; print file ":" $1 " " $2 " " errorMsg }\'',
		make = "2>/dev/null | grep -E '^.+\\([0-9]+,[0-9]+\\)' | sed -E 's/^(.+)\\(([0-9]+),([0-9]+)\\):(.*)/\\1:\\2:\\3 \\4/g'",
	},
	lintcmd = "yarn lint",
	makecmd = "yarn build",
	runcmd = "yarn start",
})

M.makeLanguage({
	pattern = { "c", "cpp" },
	grepcmd = "2>&1 | grep -E '^.+:[0-9]+:[0-9]+'",
	makecmd = "make",
	runcmd = "./out",
})
