local M = {}

M.treesitter = {
	ensure_installed = {
		"vim",
		"lua",
		"html",
		"css",
		"javascript",
		"typescript",
		"tsx",
		"c",
		"markdown",
		"markdown_inline",
		"graphql",
		"json",
		"jsonc",
		"go",
		"gomod",
	},
	indent = {
		enable = true,
		-- disable = {
		--   "python"
		-- },
	},
}

local cmp = require("cmp")
M.cmp = {
	mapping = {
		["<Tab>"] = vim.NIL,
		["<S-Tab>"] = vim.NIL,
		["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
		["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
		["<C-e>"] = cmp.mapping.abort(), -- close completion window
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		["<esc>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = function()
				if cmp.visible() then
					cmp.close()
				else
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-C>", true, true, true), "n", true)
				end
			end,
		}),
	},
}

M.mason = {
	ensure_installed = {
		-- lua stuff
		-- "lua-language-server",
		-- "stylua",

		-- web dev stuff
		"css-lsp",
		"html-lsp",
		"typescript-language-server",
		"deno",
		"prettier",
		"buf-language-server",
		"eslint_d",
		-- c/cpp stuff
		"clangd",
		"clang-format",
		-- go
		"golangci-lint",
		-- "gopls", --Install globally

		-- shell stuff
		"shfmt",
		"nil",
	},
}

local autocomplete_group = vim.api.nvim_create_augroup("vimrc_autocompletion", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sql", "mysql", "plsql" },
	callback = function()
		require("cmp").setup.buffer({
			sources = { { name = "vim-dadbod-completion" }, { name = "buffer" }, { name = "luasnip" } },
		})
	end,
	group = autocomplete_group,
})

-- git support in nvimtree
M.nvimtree = {
	git = {
		enable = true,
		ignore = false,
	},

	renderer = {
		highlight_git = true,
		icons = {
			show = {
				git = true,
			},
		},
	},
}

return M
