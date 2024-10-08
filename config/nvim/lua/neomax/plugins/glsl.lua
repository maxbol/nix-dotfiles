return {
	"tikhomirov/vim-glsl",
	lazy = false,
	config = function()
		vim.cmd([[autocmd! BufNewFile,BufRead *.vs,*.fs set ft=glsl]])
	end,
}
