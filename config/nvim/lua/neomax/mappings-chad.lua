local map = vim.keymap.set

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
map("n", "<C-Q>t", "<cmd>tabc<CR>", { desc = "Close tab" })
map("n", "<C-Q>o", "<cmd>tabonly<CR>", { desc = "Close all other tabs" })
map("n", "<C-T>", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<C-E>q", "<cmd>bd<CR>", { desc = "Close buffer" })
map("n", "<C-E>o", "<cmd>%bd|e#<CR>", { desc = "Close all other buffers" })

map("n", "<C-W>t", "<cmd>vsplit<CR><cmd>term<CR>", { desc = "Open terminal in vertical split" })

map("n", "<leader>N", "<cmd>set nu!<CR>", { desc = "Toggle Line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "Toggle Relative number" })

map("n", "<leader>qq", "<cmd>cope<CR>", { desc = "Open quickfix list" })
map("n", "<leader>qc", "<cmd>cexpr []<CR>", { desc = "Clear quickfix list" })

map("n", "<leader>fm", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "Format Files" })

-- Copilot
vim.keymap.set("i", "<C-l>", function()
	local copilot_fn = vim.fn["copilot#Accept"]
	if copilot_fn then
		local copilot_keys = vim.fn["copilot#Accept"]()
		if copilot_keys ~= "" then
			vim.api.nvim_feedkeys(copilot_keys, "i", true)
			return
		end
	end
	local keys = vim.api.nvim_replace_termcodes("<Right>", true, true, true)
	vim.api.nvim_feedkeys(keys, "i", false)
end, { expr = true, silent = true })

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
map({ "n", "x" }, "<M-a>", "<C-a>", { noremap = true, silent = true })
map({ "n", "x" }, "<M-x>", "<C-x>", { noremap = true, silent = true })

-- map("n", "<leader>fw", search_with_cache, { desc = "Telescope Live grep" })
map(
	"n",
	"<leader><leader>",
	"<cmd>Telescope find_files find_command=rg,--ignore,--files,--sortr,accessed<CR>",
	{ desc = "Telescope find (based on access time)" }
)
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Telescope Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Telescope Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Telescope Help page" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Telescope Find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Telescope Find in current buffer" })
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

-- Telescope Obsidian commands
map("n", "<leader>fn", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Find notes" })
map("n", "<leader>fN", "<cmd>ObsidianSearch<CR>", { desc = "Find word in notes" })
map("n", "<leader>fD", "<cmd>ObsidianDailies<CR>", { desc = "Find daily notes" })

-- Telescope GIT commands
map("n", "<leader>fc", "<cmd>Telescope git_commits theme=ivy<CR>", { desc = "Telescope Git commits" })
map("n", "<leader>gu", "<cmd>Telescope git_bcommits theme=ivy<CR>", { desc = "Telescope Git buffer commits" })
map("n", "<leader>gf", "<cmd>AdvancedGitSearch diff_commit_file<CR>", { desc = "Git file history" })
map("x", "<leader>gl", "<cmd>AdvancedGitSearch diff_commit_line<CR>", { desc = "Git line history" })
map("n", "<leader>gt", "<cmd>Telescope git_status theme=ivy<CR>", { desc = "Telescope Git status" })
map("n", "<leader>gb", "<cmd>Telescope git_branches theme=ivy<CR>", { desc = "Switch git branch" })
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
-- map("n", "<leader>gg", "<cmd>!tmux popup -w 90\\% -h 90\\% lazygit<CR>", { desc = "Open lazygit" })
map("n", "<leader>gg", "<cmd>Neogit kind=split_below<CR>", { desc = "Open Neogit" })

map("n", "<leader>ghc", "<cmd>Octo pr create<CR>", { desc = "Create PR" })
map("n", "<leader>ghw", "<cmd>Octo pr checks<CR>", { desc = "Watch PR checks" })
map("n", "<leader>ghl", "<cmd>Octo pr list<CR>", { desc = "List PRs" })
map("n", "<leader>fO", "<cmd>Octo actions<CR>", { desc = "Find Octo actions" })
map("n", "<leader>fh", "<cmd>Octo search<CR>", { desc = "Search on Octo" })
map("n", "<leader>ghW", '<cmd>!tmux display-popup -E "gh run watch"<CR>', { desc = "Watch workflow run" })

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal Escape terminal mode" })
map("t", "<ESC>", "<C-\\><C-N>", { desc = "Terminal Escape terminal mode" })

-- goto manpage
map({ "n", "x" }, "gm", "<cmd>vertical Man<cr>", { desc = "Goto manpage" })

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

-- Notetaking
map("n", "<leader>nn", "<cmd>ObsidianNew<CR>", { desc = "New note" })
map("n", "<leader>nd", "<cmd>ObsidianToday<CR>", { desc = "Today's daily note" })
map("n", "<leader>ny", "<cmd>ObsidianYesterday<CR>", { desc = "Yesterday's daily note" })
map("n", "<leader>nt", "<cmd>ObsidianTomorrow<CR>", { desc = "Tomorrow's daily note" })
map("n", "<leader>=", "<cmd>NoNeckPain<CR>", { desc = "Toggle no neck pain mode" })

-- toggle conceallevel for buffer
map("n", "<leader>-", function()
	local current = vim.wo.conceallevel
	if current == 0 then
		vim.wo.conceallevel = 2
	else
		vim.wo.conceallevel = 0
	end
end, { desc = "Toggle conceallevel" })

vim.api.nvim_create_autocmd("BufReadPost", { pattern = "quickfix", command = "nnoremap <buffer> <CR> <CR>" })

map("n", "<C-n>", "<cmd>cn<CR>", { desc = "Next quickfix" })
map("n", "<C-p>", "<cmd>cp<CR>", { desc = "Prev quickfix" })

-- Math stuff
map({ "n", "x" }, "<leader>m", function()
	vim.api.nvim_input(":s/\\d\\+/\\=submatch(0)/<Left>")
end, { desc = "Multiply cword" })

-- Live preview of qflist buffers
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "qf",
-- 	callback = function(event)
-- 		local opts = { buffer = event.buf, silent = true }
-- 		local init_bufnr = vim.fn.bufnr("#")
--
-- 		vim.keymap.set("n", "<C-n>", function()
-- 			vim.cmd("wincmd p") -- jump to current displayed file
-- 			if vim.fn.bufnr("%") ~= init_bufnr then
-- 				vim.cmd('bd | wincmd p | cn | execute "normal! zz" | wincmd p')
-- 			else
-- 				vim.cmd('cn | execute "normal! zz" | wincmd p')
-- 			end
-- 		end, opts)
-- 		vim.keymap.set("n", "<C-p>", function()
-- 			vim.cmd("wincmd p") -- jump to current displayed file
-- 			if vim.fn.bufnr("%") ~= init_bufnr then
-- 				vim.cmd('bd | wincmd p | cN | execute "normal! zz" | wincmd p')
-- 			else
-- 				vim.cmd('cN | execute "normal! zz" | wincmd p')
-- 			end
-- 		end, opts)
-- 	end,
-- })
