require("neomax.mappings-chad")

local map = vim.keymap.set

map("n", "<leader>fm", function()
	require("conform").format()
end, { desc = "formatting" })
map("n", "gp", "`[v`]", { desc = "select pasted text" })
map("n", "<D-d>", "<C-d>zz", { desc = "scroll down" })
map("n", "<D-u>", "<C-u>zz", { desc = "scroll up" })
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "J", "mzJ`z", { desc = "join lines" })
map("n", "N", "Nzzzv", { desc = "search previous" })
map("n", "n", "nzzzv", { desc = "search next" })
-- map("i", "kk", "")

map("v", ">", ">gv", { desc = "indent" })
map("v", "<", "<gv", { desc = "indent" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "move line up" })

-- resize windows
map("n", "<M-h>", "<C-w><", { desc = "resize window" })
map("n", "<M-l>", "<C-w>>", { desc = "resize window" })
map("n", "<M-j>", "<C-w>-", { desc = "resize window" })
map("n", "<M-k>", "<C-w>+", { desc = "resize window" })

map("x", "<leader>p", '"_dP')

map("n", "<C-y>", "mmyyp`mj", { desc = "duplicate line", noremap = true })
map("v", "<C-y>", "y`>p`[V`]", { desc = "duplicate selection", noremap = true })
