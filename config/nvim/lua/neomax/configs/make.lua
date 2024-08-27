-- some cool quickfix list experiments
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set

local M = {}

function M.make(statusmsg, cmd)
	local lines = {}
	-- local winnr = vim.fn.win_getid()
	-- local bufnr = vim.api.nvim_win_get_buf(winnr)
	print(statusmsg)

	local function on_event(_, data, event)
		if event == "stdout" or event == "stderr" then
			if data then
				for _, value in ipairs(data) do
					if value ~= "" then
						table.insert(lines, value)
					end
				end
				-- vim.list_extend(lines, data)
			end
		end

		if event == "exit" then
			vim.fn.setqflist({}, " ", {
				title = cmd,
				lines = lines,
				-- efm = vim.api.nvim_buf_get_option(bufnr, "errorformat"),
			})
			if #lines > 0 then
				vim.api.nvim_command("copen")
				print("Encountered " .. #lines .. " errors, opening quickfix list")
			else
				vim.api.nvim_command("cclose")
				print("OK!")
			end
			vim.api.nvim_command("doautocmd QuickFixCmdPost")
		end
	end

	vim.fn.jobstart(cmd, {
		on_stderr = on_event,
		on_stdout = on_event,
		on_exit = on_event,
		stdout_buffered = true,
		stderr_buffered = true,
	})
end

augroup("WorkspaceQuickfix", { clear = true })
autocmd("Filetype", {
	group = "WorkspaceQuickfix",
	pattern = { "javascript", "typescript" },
	callback = function()
		map("n", "<leader>yl", function()
			M.make(
				"Running linter...",
				'yarn lint 2>/dev/null | awk \'/^(\\/.+)$/ { file=$1; } /^\\s*[0-9]+:[0-9]+/ {  errorMsg=""; for (i=3;i<=NF;++i) errorMsg=errorMsg " " $i; print file ":" $1 " " $2 " " errorMsg }\''
			)
		end, { desc = "Yarn lint" })
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
			{ desc = "Yarn build" }
		)
	end,
})

autocmd("Filetype", {
	group = "WorkspaceQuickfix",
	pattern = { "go" },
	callback = function()
		map("n", "<leader>yl", function()
			M.make(
				"Running linter...",
				"golangci-lint run --timeout 300s --config .golangci.yml ./... 2>/dev/null | grep -E '^.+:[0-9]+:[0-9]+'"
			)
		end, { desc = "Golangci lint" })
		map("n", "<leader>yb", function()
			M.make("Building project...", "go build ./... 2>&1 | grep -E '^.+:[0-9]+:[0-9]+'")
		end, { desc = "Go build" })
	end,
})

autocmd("Filetype", {
	group = "WorkspaceQuickfix",
	pattern = { "zig" },
	callback = function()
		map("n", "<leader>yb", function()
			M.make("Building project...", "zig build 2>&1 | grep -E '^.+:[0-9]+:[0-9]+'")
		end, { desc = "Zig build" })
		map("n", "<leader>yr", function()
			M.make("Building and running project...", "zig build run 2>&1 | grep -E '^.+:[0-9]+:[0-9]+'")
		end, { desc = "Zig build & run" })
	end,
})
