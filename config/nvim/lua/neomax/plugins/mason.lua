return {
	"williamboman/mason.nvim",
	cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
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
			"eslint-lsp",
			"eslint_d",
			-- c/cpp stuff
			-- "clangd",
			-- "clang-format",
			-- go
			-- "golangci-lint",
			-- "gopls", --Install globally
			"pyright",

			-- shell stuff
			"shfmt",
			-- "nil",
			--
			"sqlfluff",
			"sqlfmt",
		},
	},
	config = function(_, opts)
		require("mason").setup(opts)

		-- custom nvchad cmd to install all mason binaries listed
		vim.api.nvim_create_user_command("MasonInstallAll", function()
			if opts.ensure_installed and #opts.ensure_installed > 0 then
				vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
			end
		end, {})

		vim.g.mason_binaries_list = opts.ensure_installed
	end,
}
