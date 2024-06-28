-- some cool quickfix list experiments
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set

augroup("WorkspaceQuickfix", { clear = true })
autocmd("Filetype", {
	group = "WorkspaceQuickfix",
	pattern = { "javascript", "typescript" },
	callback = function()
		map(
			"n",
			"<leader>yl",
			[[:cope<CR>:cexpr []<CR>:cexpr system("yarn lint 2>/dev/null | awk '/^(\\/.+)$/ { file=$1; } /^\\s*[0-9]+:[0-9]+/ {  errorMsg=\"\"; for (i=3;i<=NF;++i) errorMsg=errorMsg \" \" $i; print file \":\" $1 \" \" $2 \" \" errorMsg }'")<CR>]],
			{ desc = "Yarn lint" }
		)
		map(
			"n",
			"<leader>yb",
			[[:cope<CR>:cexpr []<CR>:cexpr system("yarn build 2>/dev/null | grep -E '^.+\\([0-9]+,[0-9]+\\)' | sed -E 's/^(.+)\\(([0-9]+),([0-9]+)\\):(.*)/\\1:\\2:\\3 \\4/g'")<CR>]],
			{ desc = "Yarn build" }
		)
	end,
})

autocmd("Filetype", {
	group = "WorkspaceQuickfix",
	pattern = { "go" },
	callback = function()
		map(
			"n",
			"<leader>yl",
			[[:cope<CR>:cexpr []<CR>:cexpr system("golangci-lint run --timeout 300s --config .golangci.yml ./... 2>/dev/null | grep -E '^.+:[0-9]+:[0-9]+'")<CR>]],
			{ desc = "Golangci lint" }
		)
		map(
			"n",
			"<leader>yb",
			[[:cope<CR>:cexpr []<CR>:cexpr system("go build ./... 2>&1 | grep -E '^.+:[0-9]+:[0-9]+'")<CR>]],
			{ desc = "Golangci lint" }
		)
	end,
})

autocmd("Filetype", {
	group = "WorkspaceQuickfix",
	pattern = { "zig" },
	callback = function()
		map(
			"n",
			"<leader>yb",
			[[:cope<CR>:cexpr []<CR>:cexpr system("zig build 2>&1 | grep -E '^.+:[0-9]+:[0-9]+'")<CR>]],
			{ desc = "Zig build" }
		)
	end,
})
