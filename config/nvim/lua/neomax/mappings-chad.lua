local map = vim.keymap.set

map("i", "<C-b>", "<ESC>^i", { desc = "Move Beginning of line" })
map("i", "<C-e>", "<End>", { desc = "Move End of line" })
map("i", "<C-h>", "<Left>", { desc = "Move Left" })
map("i", "<C-l>", "<Right>", { desc = "Move Right" })
map("i", "<C-j>", "<Down>", { desc = "Move Down" })
map("i", "<C-k>", "<Up>", { desc = "Move Up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General Clear highlights" })

--[[ map("n", "<C-h>", "<C-w>h", { desc = "Switch Window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Switch Window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Switch Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Switch Window up" }) ]]

map("n", "<C-s>", "<cmd>w<CR>", { desc = "File Save" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "File Copy whole" })

map("n", "<C-Q>q", "<cmd>:qa<CR>", { desc = "Quit Neovim" })
map("n", "<C-Q>t", "<cmd>:tabc <CR>", { desc = "Close tab" })
map("n", "<C-Q>o", "<cmd>:tabonly <CR>", { desc = "Close all other tabs" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "Toggle Line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "Toggle Relative number" })

map("n", "<leader>fm", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "Format Files" })

-- global lsp mappings
-- map("n", "<leader>lf", vim.diagnostic.open_float, { desc = "Lsp floating diagnostics" })
-- map("n", "[d", vim.diagnostic.goto_prev, { desc = "Lsp prev diagnostic" })
-- map("n", "]d", vim.diagnostic.goto_next, { desc = "Lsp next diagnostic" })
-- map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Lsp diagnostic loclist" })

-- tabufline
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "Buffer New" })

-- map("n", "<tab>", function()
--   require("nvchad.tabufline").next()
-- end, { desc = "Buffer Goto next" })

-- map("n", "<S-tab>", function()
--   require("nvchad.tabufline").prev()
-- end, { desc = "Buffer Goto prev" })

-- map("n", "<leader>x", function()
--   require("nvchad.tabufline").close_buffer()
-- end, { desc = "Buffer Close" })

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

-- telescope
local telescope = require("telescope.builtin")
local telescope_state = require("telescope.state")

local last_search = nil

function search_with_cache()
	if last_search == nil then
		telescope.live_grep()

		local cached_pickers = telescope_state.get_global_key("cached_pickers") or {}
		last_search = cached_pickers[1]
	else
		telescope.resume({ picker = last_search })
	end
end

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
map("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Git commit" })
map("n", "<leader>gP", "<cmd>Git push<CR>", { desc = "Git push" })
map("n", "<leader>gp", "<cmd>Git pull<CR>", { desc = "Git pull" })
map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Open diffview in new tab" })

map("n", "<leader>ghc", "<cmd>Octo pr create<CR>", { desc = "Create PR" })
map("n", "<leader>ghd", "<cmd>Octo pr diff<CR>", { desc = "Show PR diff" })
map("n", "<leader>ghw", "<cmd>Octo pr checks<CR>", { desc = "Watch PR checks" })
map("n", "<leader>ghm", "<cmd>Octo pr merge<CR>", { desc = "Merge PR" })
map("n", "<leader>ghs", "<cmd>Octo pr merge squash<CR>", { desc = "Squash and merge PR" })
map("n", "<leader>ghl", "<cmd>Octo pr list<CR>", { desc = "List PRs" })
map("n", "<leader>fO", "<cmd>Octo actions<CR>", { desc = "Find Octo actions" })
map("n", "<leader>fh", "<cmd>Octo search<CR>", { desc = "Search on Octo" })

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal Escape terminal mode" })

-- new terminals
-- map("n", "<leader>h", function()
--   require("nvchad.term").new { pos = "sp", size = 0.3 }
-- end, { desc = "Terminal New horizontal term" })

-- map("n", "<leader>v", function()
--   require("nvchad.term").new { pos = "vsp", size = 0.3 }
-- end, { desc = "Terminal New vertical window" })

-- toggleable
-- map({ "n", "t" }, "<A-v>", function()
--   require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm", size = 0.3 }
-- end, { desc = "Terminal Toggleable vertical term" })

-- map({ "n", "t" }, "<A-h>", function()
--   require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm", size = 0.3 }
-- end, { desc = "Terminal New horizontal term" })

-- map({ "n", "t" }, "<A-i>", function()
--   require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
-- end, { desc = "Terminal Toggle Floating term" })

map("t", "<ESC>", function()
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_close(win, true)
end, { desc = "Terminal Close term in terminal mode" })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "Whichkey all keymaps" })

map("n", "<leader>wk", function()
	vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
end, { desc = "Whichkey query lookup" })

-- blankline
map("n", "<leader>cc", function()
	local config = { scope = {} }
	config.scope.exclude = { language = {}, node_type = {} }
	config.scope.include = { node_type = {} }
	local node = require("ibl.scope").get(vim.api.nvim_get_current_buf(), config)

	if node then
		local start_row, _, end_row, _ = node:range()
		if start_row ~= end_row then
			vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start_row + 1, 0 })
			vim.api.nvim_feedkeys("_", "n", true)
		end
	end
end, { desc = "Blankline Jump to current context" })
