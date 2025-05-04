vim.o.guifont = "Iosevka:h18" -- text below applies for VimScript
vim.g.neovide_window_blurred = true
vim.g.neovide_opacity = 0.8
vim.g.neovide_normal_opacity = 0.8

vim.g.neovide_scale_factor = 1.0
local change_scale_factor = function(delta)
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end
print("setting neovide specific keymaps")
vim.keymap.set("n", "<D-=>", function()
	print("zoom in")
	change_scale_factor(1.10)
end)
vim.keymap.set("n", "<D-->", function()
	print("zoom out")
	change_scale_factor(1 / 1.10)
end)

vim.keymap.set({ "n", "v", "i", "x", "c" }, "<D-n>", ":silent exec '!neovide'<CR>")

vim.keymap.set("v", "<D-c>", '"+y') -- Copy
vim.keymap.set("n", "<C-V>", '"+P') -- Paste normal mode
vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode
vim.keymap.set("i", "<C-V>", '<ESC>l"+Pli') -- Paste insert mode
