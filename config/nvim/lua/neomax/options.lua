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
opt.cursorlineopt = "both"

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

-- interval for writing swap file to disk, also used by gitsigns
o.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")

-- g.mapleader = " "

-- disable some default providers
g["loaded_node_provider"] = 0
g["loaded_python3_provider"] = 0
g["loaded_perl_provider"] = 0
g["loaded_ruby_provider"] = 0

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has("win32") ~= 0
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH
