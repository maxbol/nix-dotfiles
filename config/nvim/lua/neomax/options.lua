local opt = vim.opt
local o = vim.o
local g = vim.g

-- add yours here!

opt.termguicolors = true
opt.clipboard = "unnamedplus"

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
g.markdown_recommended_style = 0

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false
opt.cursorline = true
-- opt.cursorlineopt = "both"

g.db_ui_use_nerd_fonts = 1
g.db_ui_execute_on_save = 1
g.completion_matching_strategy_list = { "exact", "substring" }
g.completion_matching_ignore_case = 1

opt.relativenumber = true

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2

opt.fillchars = { eob = " " }
o.ignorecase = true
o.smartcase = true
o.mouse = "a"

-- Numbers
o.number = true
o.numberwidth = 2
o.ruler = false

-- disable nvim intro
opt.shortmess:append("sI")

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true

-- Copilot settings
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

-- interval for writing swap file to disk, also used by gitsigns
o.updatetime = 250

o.scrolloff = 20

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")

-- g.mapleader = " "

-- disable some default providers
g["loaded_node_provider"] = 0
g["loaded_python3_provider"] = 0
g["loaded_perl_provider"] = 0
g["loaded_ruby_provider"] = 0

-- try to add to efm
-- vim.opt.errorformat:prepend("%f\\:%l\\:%c\\ %m")
-- vim.cmd("let &efm .= ',%f:%l:%c\\ %t\\ %m'")
-- vim.cmd([[let &efm .= ',%*[^"]"%f"%*\D%l:%c %t %m']])

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has("win32") ~= 0
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

-- automatically start telescope frecency when entering a workspace
-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	callback = function()
-- 		if vim.fn.argv(0) == "" or vim.fn.argv(0) == "." then
-- 			require("telescope").extensions.frecency.frecency({ workspace = "CWD" })
-- 		end
-- 	end,
-- })
--
--

-- https://github.com/olimorris/persisted.nvim/issues/84#issuecomment-1700996731
vim.api.nvim_create_autocmd({ "VimLeave" }, {
	callback = function()
		vim.cmd("!notify-send ''")
		vim.cmd("sleep 10m")
	end,
})

g["surround_no_mappings"] = 1
