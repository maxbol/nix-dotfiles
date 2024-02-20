return {
	"Shatur/neovim-ayu",
	config = function()
		-- transparent background and gutter
		vim.cmd([[
      augroup user_colors
        autocmd!
        autocmd ColorScheme * highlight ErrorMsg guifg=#d95757 guibg=NONE
      augroup END
    ]])
		require("ayu").setup({
			overrides = {
				Normal = { bg = "None" },
				ColorColumn = { bg = "None" },
				SignColumn = { bg = "None" },
				Folded = { bg = "None" },
				FoldColumn = { bg = "None" },
				CursorColumn = { bg = "None" },
				WhichKeyFloat = { bg = "None" },
				VertSplit = { bg = "None" },
			},
		})
		-- set the colorscheme
		vim.cmd([[
      colorscheme ayu-dark
    ]])
	end,
}
