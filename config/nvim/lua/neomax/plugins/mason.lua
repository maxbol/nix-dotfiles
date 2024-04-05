return {
	"williamboman/mason.nvim",
	opts = {
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
	},
}
