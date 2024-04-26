require("neomax.mappings-chad")

-- add yours here

local map = vim.keymap.set
local nomap = vim.keymap.del

-- map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "kk", "<ESC>")
-- map("i", "<ESC>", "<C-c>")

map("n", "<leader>fm", function()
	require("conform").format()
end, { desc = "formatting" })
map("n", "gp", "`[v`]", { desc = "select pasted text" })
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "J", "mzJ`z", { desc = "join lines" })
map("n", "N", "Nzzzv", { desc = "search previous" })
map("n", "n", "nzzzv", { desc = "search next" })

map("v", ">", ">gv", { desc = "indent" })
map("v", "<", "<gv", { desc = "indent" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "move line up" })

map("x", "<leader>p", '"_dP')

-- disable some keybinds
-- needed for tmux-navigator to behave properly
-- nomap("n", "<C-h>")
-- nomap("n", "<C-j>")
-- nomap("n", "<C-k>")
-- nomap("n", "<C-l>")
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
