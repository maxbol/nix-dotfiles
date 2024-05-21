local lspconfig = require("lspconfig")
local map = vim.keymap.set

local on_attach = function(client, bufnr)
	local function opts(desc)
		return { buffer = bufnr, desc = desc }
	end
	map("n", "gD", vim.lsp.buf.declaration, opts("Lsp Go to declaration"))
	map("n", "gd", vim.lsp.buf.definition, opts("Lsp Go to definition"))
	map("n", "gwd", ":vsplit | lua vim.lsp.buf.definition()<CR>", opts("Lsp Go to definition in new vertical split"))
	map("n", "gwD", ":vsplit | lua vim.lsp.buf.declaration()<CR>", opts("Lsp Go to declaration in new vertical split"))
	map("n", "gWd", ":split | lua vim.lsp.buf.definition()<CR>", opts("Lsp Go to definition in new horizontal split"))
	map("n", "gWD", ":split | lua vim.lsp.buf.declaration()<CR>", opts("Lsp Go to declaration in new horizontal split"))

	map("n", "K", "<cmd>Lspsaga hover_doc<CR>")

	map("n", "gi", vim.lsp.buf.implementation, opts("Lsp Go to implementation"))
	map("n", "<leader>sh", vim.lsp.buf.signature_help, opts("Lsp Show signature help"))
	map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Lsp Add workspace folder"))
	map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Lsp Remove workspace folder"))

	map("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts("Lsp List workspace folders"))

	map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Lsp Go to type definition"))

	map("n", "<leader>ra", "<cmd>Lspsaga rename ++project<CR>", opts("Rename code symbol"))

	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Lsp Code action"))
	map("n", "gr", "<cmd>Lspsaga finder<CR>")

	map("n", "<leader>lf", vim.diagnostic.open_float, { desc = "Lsp floating diagnostics" })
	map("n", "[d", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Lsp prev diagnostic" })
	map("n", "]d", "<Cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Lsp next diagnostic" })
	map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Lsp diagnostic loclist" })

	if client.name == "eslint" then
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			command = "EslintFixAll",
		})
	end

	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.DocumentRangeFormattingProvider = false
	end
end

local on_init = function(client, _)
	if client.supports_method("textDocument/semanticTokens") then
		client.server_capabilities.semanticTokensProvider = nil
	end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

-- if you just want default config for the servers then put them in a table
local servers = {
	"html",
	"cssls",
	"clangd",
	"bufls",
	-- "tsserver",
	"eslint",
	"nixd",
	"gopls",
	"zls",
	"dockerls",
	"docker_compose_language_service",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_init = on_init,
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

lspconfig.lua_ls.setup({
	on_init = on_init,
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

lspconfig.clangd.setup({
	on_init = on_init,
	on_attach = on_attach,
	capabilities = {
		offsetEncoding = { "utf-16" },
	},
	root_dir = function(fname)
		return require("lspconfig.util").root_pattern(
			"Makefile",
			"configure.ac",
			"configure.in",
			"config.h.in",
			"meson.build",
			"meson_options.txt",
			"build.ninja"
		)(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(fname) or require(
			"lspconfig.util"
		).find_git_ancestor(fname)
	end,
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
		"--function-arg-placeholders",
		"--fallback-style=llvm",
	},
	init_options = {
		usePlaceholders = true,
		completeUnimported = true,
		clangdFileStatus = true,
	},
})

lspconfig.omnisharp.setup({
	on_init = on_init,
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "/home/max/.nix-profile/bin/OmniSharp" },
	settings = {
		FormattingOptions = {
			OrganizeImports = true,
		},
		RoslynExtensionsOptions = {
			EnableAnalyzersSupport = true,
			EnableImportCompletion = true,
		},
	},
})

lspconfig["tsserver"].setup({
	on_init = on_init,
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = "literal",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = false,
				includeInlayVariableTypeHints = false,
				includeInlayPropertyDeclarationTypeHints = false,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
		javascript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
	},
})

--[[ if not configs.golangcilsp then
	configs.golangcilsp = {
		default_config = {
			cmd = { "golangci-lint-langserver" },
			root_dir = lspconfig.util.root_pattern(".git", "go.mod"),
			init_options = {
				command = {
					"golangci-lint",
					"run",
					"--enable-all",
					"--disable",
					"lll",
					"--out-format",
					"json",
					"--issues-exit-code=1",
				},
			},
		},
	}
end
lspconfig.golangci_lint_ls.setup({
	filetypes = { "go", "gomod" },
}) ]]

vim.lsp.set_log_level("ERROR")
