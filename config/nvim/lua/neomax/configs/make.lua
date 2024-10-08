-- some cool quickfix list experiments
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set
local g = vim.g

local is_tmux = vim.env.TMUX ~= nil

-- [[
-- ~/.local/state/nvim/neomax/make/Users/maxbolotin/Source/some-repo/{make,run}
-- zig build run
-- ]]

if g.makefile_root == nil then
	g.makefile_root = vim.fn.stdpath("data") .. "/make"
end

local M = {}

function M.getProjectFiles(cwd)
	local dir = g.makefile_root .. "/" .. cwd

	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end

	local makefile = dir .. "/make"
	local runfile = dir .. "/run"
	return { makefile = makefile, runfile = runfile }
end

function M.getLastCmds(defaults, cwd)
	local files = M.getProjectFiles(cwd)
	local makecmd
	local runcmd

	if vim.fn.filereadable(files.makefile) == 0 then
		makecmd = defaults.makecmd
	else
		makecmd = vim.fn.readfile(files.makefile)[1]
	end

	if vim.fn.filereadable(files.runfile) == 0 then
		runcmd = defaults.runcmd
	else
		runcmd = vim.fn.readfile(files.runfile)[1]
	end

	return { makecmd = makecmd, runcmd = runcmd }
end

function M.storeMakeCmd(cmd, cwd)
	local files = M.getProjectFiles(cwd)
	vim.fn.writefile({ cmd }, files.makefile)
end

function M.storeRunCmd(cmd, cwd)
	local files = M.getProjectFiles(cwd)
	vim.fn.writefile({ cmd }, files.runfile)
end

function M.getCmdWithArgs(cmd, cb)
	vim.ui.input({
		prompt = "Arguments:",
		completion = "shellcmd",
		default = cmd,
	}, function(cmd_with_args)
		if not cmd_with_args then
			return
		end

		cb(cmd_with_args)
	end)
end

function M.make(statusmsg, cmd, grepcmd, on_success, on_failure)
	local lines = {}
	-- local winnr = vim.fn.win_getid()
	-- local bufnr = vim.api.nvim_win_get_buf(winnr)
	print(statusmsg .. ": " .. cmd)

	cmd = string.format("%s %s", cmd, grepcmd)

	local function on_output(_, data, event)
		if data then
			for _, value in ipairs(data) do
				if value ~= "" then
					table.insert(lines, value)
				end
			end
			-- vim.list_extend(lines, data)
		end
	end

	local function on_exit(_, data, event)
		vim.fn.setqflist({}, " ", {
			title = cmd,
			lines = lines,
			-- efm = vim.api.nvim_buf_get_option(bufnr, "errorformat"),
		})
		if #lines > 0 then
			vim.api.nvim_command("copen")
			print("Encountered " .. #lines .. " errors, opening quickfix list")
			if on_failure then
				on_failure()
			end
		else
			vim.api.nvim_command("cclose")
			print("OK!")
			if on_success then
				on_success()
			end
		end
		vim.api.nvim_command("doautocmd QuickFixCmdPost")
	end

	vim.fn.jobstart(cmd, {
		on_stderr = on_output,
		on_stdout = on_output,
		on_exit = on_exit,
		stdout_buffered = true,
		stderr_buffered = true,
	})
end

function M.run(cmd, on_success, on_failure)
	local ui = vim.api.nvim_list_uis()[1]

	print("Running project: " .. cmd)

	if is_tmux and ui ~= nil then
		local width = ui.width

		if width > 200 then
			cmd = string.format("tmux split-window -h %s \\; set-option remain-on-exit failed", cmd)
		else
			cmd = string.format("tmux new-window %s \\; set-option remain-on-exit failed", cmd)
		end
	end

	local success = os.execute(cmd)
	if success and on_success then
		on_success()
	elseif not success and on_failure then
		on_failure()
	end
end

augroup("WorkspaceQuickfix", { clear = true })
autocmd("Filetype", {
	group = "WorkspaceQuickfix",
	pattern = { "javascript", "typescript" },
	callback = function(o)
		map("n", "<leader>yl", function()
			M.make(
				"Running linter...",
				'yarn lint 2>/dev/null | awk \'/^(\\/.+)$/ { file=$1; } /^\\s*[0-9]+:[0-9]+/ {  errorMsg=""; for (i=3;i<=NF;++i) errorMsg=errorMsg " " $i; print file ":" $1 " " $2 " " errorMsg }\''
			)
		end, { desc = "Yarn lint", buffer = o.buf })
		map(
			"n",
			"<leader>yb",
			function()
				M.make(
					"Building project...",
					"yarn build 2>/dev/null | grep -E '^.+\\([0-9]+,[0-9]+\\)' | sed -E 's/^(.+)\\(([0-9]+),([0-9]+)\\):(.*)/\\1:\\2:\\3 \\4/g'"
				)
			end,
			-- [[:cope<CR>:cexpr ["Building project..."]<CR>:cexpr system("yarn build 2>/dev/null | grep -E '^.+\\([0-9]+,[0-9]+\\)' | sed -E 's/^(.+)\\(([0-9]+),([0-9]+)\\):(.*)/\\1:\\2:\\3 \\4/g'")<CR>]],
			{ desc = "Yarn build", buffer = o.buf }
		)
	end,
})

autocmd("Filetype", {
	group = "WorkspaceQuickfix",
	pattern = { "go" },
	callback = function(o)
		map("n", "<leader>yl", function()
			M.make(
				"Running linter...",
				"golangci-lint run --timeout 300s --config .golangci.yml ./... 2>/dev/null | grep -E '^.+:[0-9]+:[0-9]+'"
			)
		end, { desc = "Golangci lint", buffer = o.buf })
		map("n", "<leader>yb", function()
			M.make("Building project...", "go build ./... 2>&1 | grep -E '^.+:[0-9]+:[0-9]+'")
		end, { desc = "Go build", buffer = o.buf })
	end,
})

function M.makeLanguage(opts)
	local grepcmd = opts.grepcmd
	local default_makecmd = opts.default_makecmd
	local default_runcmd = opts.default_runcmd

	local cmds_per_cwd = {}

	local function getCmdsByCwd(cwd)
		if cmds_per_cwd[cwd] == nil then
			cmds_per_cwd[cwd] = M.getLastCmds({
				makecmd = default_makecmd,
				runcmd = default_runcmd,
			}, cwd)
		end
		return cmds_per_cwd[cwd]
	end

	autocmd("Filetype", {
		group = "WorkspaceQuickfix",
		pattern = { opts.filetype },
		callback = function(o)
			map("n", "<leader>yb", function()
				local cmds = getCmdsByCwd(vim.fn.getcwd())
				M.make("Building project...", cmds.makecmd, grepcmd)
			end, { desc = "Build", buffer = o.buf })

			map("n", "<leader>yB", function()
				local cwd = vim.fn.getcwd()
				local cmds = getCmdsByCwd(cwd)

				M.getCmdWithArgs(cmds.makecmd, function(cmd)
					cmds_per_cwd[cwd].makecmd = cmd
					M.make("Building project...", cmd, grepcmd, function()
						M.storeMakeCmd(cmd)
					end)
				end)
			end, { desc = "Zig build with args", buffer = o.buf })

			map("n", "<leader>yr", function()
				local cmds = getCmdsByCwd(vim.fn.getcwd())

				M.make("Building and running project...", cmds.makecmd, grepcmd, function()
					M.run(cmds.runcmd)
				end)
			end, { desc = "Run", buffer = o.buf })

			map("n", "<leader>yR", function()
				local cwd = vim.fn.getcwd()
				local cmds = getCmdsByCwd(cwd)

				M.getCmdWithArgs(cmds.runcmd, function(cmd)
					cmds_per_cwd[cwd].runcmd = cmd
					M.make("Building and running project...", cmds.makecmd, grepcmd, function()
						M.run(cmd, function()
							M.storeRunCmd(cmd)
						end)
					end)
				end)
			end, { desc = "Run with args", buffer = o.buf })
		end,
	})
end

M.makeLanguage({
	filetype = "zig",
	grepcmd = "2>&1 | grep -E '^.+:[0-9]+:[0-9]+'",
	default_makecmd = "zig build",
	default_runcmd = "zig build run",
})
