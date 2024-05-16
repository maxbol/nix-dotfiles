local map = vim.keymap.set
local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd

map("i", "<C-b>", "<ESC>^i", { desc = "Move Beginning of line" })
map("i", "<C-e>", "<End>", { desc = "Move End of line" })
map("i", "<C-h>", "<Left>", { desc = "Move Left" })
map("i", "<C-l>", "<Right>", { desc = "Move Right" })
map("i", "<C-j>", "<Down>", { desc = "Move Down" })
map("i", "<C-k>", "<Up>", { desc = "Move Up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General Clear highlights" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "File Save" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "File Copy whole" })

map("n", "<C-Q>q", "<cmd>qa<CR>", { desc = "Quit Neovim" })
map("n", "<C-Q>t", "<cmd>tabc <CR>", { desc = "Close tab" })
map("n", "<C-Q>o", "<cmd>tabonly <CR>", { desc = "Close all other tabs" })

map("n", "<C-W>t", "<cmd>vsplit<CR><cmd>term<CR>", { desc = "Open terminal in vertical split" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "Toggle Line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "Toggle Relative number" })

map("n", "<leader>qq", "<cmd>cope<CR>", { desc = "Open quickfix list" })
map("n", "<leader>qc", "<cmd>cexpr []<CR>", { desc = "Clear quickfix list" })

map("n", "<leader>fm", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "Format Files" })

-- Comment
map("n", "<leader>/", function()
	require("Comment.api").toggle.linewise.current()
end, { desc = "Comment Toggle" })

map(
	"v",
	"<leader>/",
	"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
	{ desc = "Comment Toggle" }
)

-- Extra incremente/decrement mappings to allow me to keep C-A as my tmux leader :)
map("n", "<M-a>", "<C-a>", { noremap = true, silent = true })
map("n", "<M-x>", "<C-x>", { noremap = true, silent = true })

-- telescope
local telescope = require("telescope.builtin")
local telescope_state = require("telescope.state")

-- map("n", "<leader>fw", search_with_cache, { desc = "Telescope Live grep" })
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Telescope Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Telescope Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Telescope Help page" })

map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Telescope Find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Telescope Find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "Telescope Git commits" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Telescope Find files" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Telescope Find symbol in document" })
map("n", "<leader>fS", function()
	require("telescope.builtin").lsp_dynamic_workspace_symbols({
		symbols = { "function", "class", "interface", "method", "enum" },
	})
end, { desc = "Telescope Find symbol in workspace" })
map(
	"n",
	"<leader>fa",
	"<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
	{ desc = "Telescope Find all files" }
)

-- Telescope GIT commands
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "Telescope Git status" })
map("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "Switch git branch" })
map("n", "<leader>gHf", "<cmd>AdvancedGitSearch diff_commit_file<CR>", { desc = "Git file history" })
map("n", "<leader>gHl", "<cmd>AdvancedGitSearch diff_commit_line<CR>", { desc = "Git line history" })
map("n", "<leader>gB", "<cmd>AdvancedGitSearch diff_branch_file<CR>", { desc = "Git file branch diff" })
map("n", "<leader>gC", "<cmd>AdvancedGitSearch changed_on_branch<CR>", { desc = "Git changes on current branch" })

-- Other Git stuff
map("n", "<leader>gc", "<cmd>G commit<CR>", { desc = "Git commit" })
map("n", "<leader>gP", "<cmd>G push<CR>", { desc = "Git push" })
map("n", "<leader>gp", "<cmd>G pull<CR>", { desc = "Git pull" })
map("n", "<leader>gs", "<cmd>G<CR>", { desc = "Git status" })
map("n", "<leader>gS", "<cmd>G stash<CR>", { desc = "Git stash" })
map("n", "<leader>gx", "<cmd>G stash pop<CR>", { desc = "Git stash pop" })
map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Open diffview in new tab" })

map("n", "<leader>ghc", "<cmd>Octo pr create<CR>", { desc = "Create PR" })
map("n", "<leader>ghw", "<cmd>Octo pr checks<CR>", { desc = "Watch PR checks" })
map("n", "<leader>ghl", "<cmd>Octo pr list<CR>", { desc = "List PRs" })
map("n", "<leader>fO", "<cmd>Octo actions<CR>", { desc = "Find Octo actions" })
map("n", "<leader>fh", "<cmd>Octo search<CR>", { desc = "Search on Octo" })
map("n", "<leader>ghW", '<cmd>!tmux display-popup -E "gh run watch"<CR>', { desc = "Watch workflow run" })

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal Escape terminal mode" })
map("t", "<ESC>", "<C-\\><C-N>", { desc = "Terminal Escape terminal mode" })

-- some cool quickfix list experiments
augroup("WorkspaceQuickfix", { clear = true })
autocmd("Filetype", {
	group = "WorkspaceQuickfix",
	pattern = { "javascript", "typescript" },
	callback = function()
		map(
			"n",
			"<leader>yl",
			[[:cope<CR>:cexpr []<CR>:cexpr system("yarn lint 2>/dev/null \| awk '/^(\\/.+)$/ { file=$1; } /^\\s*[0-9]+:[0-9]+/ {  errorMsg=\"\"; for (i=3;i<=NF;++i) errorMsg=errorMsg \" \" $i; print file \":\" $1 \" \" $2 \" \" errorMsg }'")<CR>]],
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

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "Whichkey all keymaps" })

map("n", "<leader>wk", function()
	vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
end, { desc = "Whichkey query lookup" })

-- custom surround mappings, so that we can have both s and S dedicated to leap in
-- all modes
map("n", "ds", "<Plug>Dsurround", { desc = "Delete Surround" })
map("n", "cs", "<Plug>Csurround", { desc = "Change Surround" })
map("n", "cS", "<Plug>CSurround", { desc = "Change and indent Surround" })
map("n", "yS", "<Plug>YSurround", { desc = "Surround on newline and indent" })
map("n", "ys", "<Plug>Ysurround", { desc = "Surround (with vim motion)" })
map("n", "yss", "<Plug>Yssurround", { desc = "Surround entire line" })
map("n", "ySs", "<Plug>YSsurround", { desc = "Surround on newline" })
map("n", "ySS", "<Plug>YSsurround", { desc = "Surround entire line on newline" })
map("x", "O", "<Plug>VSurround", { desc = "Visual Surround" })
map("x", "gO", "<Plug>VSurround", { desc = "Visual indent Surround" })
