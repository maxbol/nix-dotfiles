-- General Neovim Options --

local opt = vim.opt

-- set leader
vim.g.mapleader = ","

-- set number lines
vim.opt.relativenumber = true
vim.opt.number = true

-- disable persistent search hightlight
vim.opt.hlsearch = false

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- turn on termguicolors for colorscheme to work
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- set persistent undo
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.nvim/undofiles")

-- only one status line for all files
vim.opt.laststatus = 3
