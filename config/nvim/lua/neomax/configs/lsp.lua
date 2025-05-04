local lspconfig = require("lspconfig")
local telescope_builtin = require("telescope.builtin")
local map = vim.keymap.set

-- Add borders to floating windows
local lsp_float_border = {
	{ "🭽", "FloatBorder" },
	{ "▔", "FloatBorder" },
	{ "🭾", "FloatBorder" },
	{ "▕", "FloatBorder" },
	{ "🭿", "FloatBorder" },
	{ "▁", "FloatBorder" },
	{ "🭼", "FloatBorder" },
	{ "▏", "FloatBorder" },
}
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or lsp_float_border
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

local on_attach = function(client, bufnr)
	local function opts(desc)
		return { buffer = bufnr, desc = desc }
	end
	-- lsp_status.on_attach(client)

	map("n", "gD", vim.lsp.buf.declaration, opts("Lsp Go to declaration"))
	map("n", "gd", ":Telescope lsp_definitions theme=cursor<CR>", opts("Lsp Go to definition"))
	map("n", "gwd", ":vsplit | lua vim.lsp.buf.definition()<CR>", opts("Lsp Go to definition in new vertical split"))
	map("n", "gwD", ":vsplit | lua vim.lsp.buf.declaration()<CR>", opts("Lsp Go to declaration in new vertical split"))
	map("n", "gWd", ":split | lua vim.lsp.buf.definition()<CR>", opts("Lsp Go to definition in new horizontal split"))
	map("n", "gWD", ":split | lua vim.lsp.buf.declaration()<CR>", opts("Lsp Go to declaration in new horizontal split"))
	map("n", "gr", ":Telescope lsp_references theme=cursor<CR>", opts("Lsp References"))
	map("n", "gi", ":Telescope lsp_implementations theme=cursor<CR>", opts("Lsp Go to implementation"))

	-- map("n", "K", "<cmd>Lspsaga hover_doc<CR>")

	map("n", "<leader>sh", vim.lsp.buf.signature_help, opts("Lsp Show signature help"))
	map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Lsp Add workspace folder"))
	map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Lsp Remove workspace folder"))

	map("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts("Lsp List workspace folders"))

	map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Lsp Go to type definition"))
	map("n", "<leader>ra", vim.lsp.buf.rename, opts("Lsp Rename"))

	-- map("n", "<leader>ra", "<cmd>Lspsaga rename ++project<CR>", opts("Rename code symbol"))

	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Lsp Code action"))
	-- map("n", "gr", "<cmd>Lspsaga finder<CR>")

	map("n", "<leader>lf", vim.diagnostic.open_float, { desc = "Lsp floating diagnostics" })
	map("n", "]d", vim.diagnostic.goto_prev, { desc = "Lsp prev diagnostic" })
	map("n", "]d", vim.diagnostic.goto_next, { desc = "Lsp next diagnostic" })
	map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Lsp diagnostic loclist" })

	if client.name == "eslint" then
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			command = "EslintFixAll",
		})
	end

	if client.name == "ts_ls" then
		-- client.server_capabilities.documentFormattingProvider = false
		-- client.server_capabilities.DocumentRangeFormattingProvider = false
	end
end

local on_init = function(client, _)
	-- if client.supports_method("textDocument/semanticTokens") then
	-- 	client.server_capabilities.semanticTokensProvider = nil
	-- end
end

local capabilities = require("blink.cmp").get_lsp_capabilities()
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
--
-- capabilities = vim.tbl_extend(
-- 	"keep",
-- 	capabilities or {},
-- 	require("blink.cmp").get_lsp_capabilities({
-- 		textDocument = { completion = { completionItem = { snippetSupport = true } } },
-- 	})
-- )

-- capabilities = vim.tbl_extend("keep", capabilities or {}, lsp_status.capabilities)

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

capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

-- if you just want default config for the servers then put them in a table
local servers = {
	"cssls",
	-- "clangd",
	"buf_ls",
	-- "tsserver",
	"eslint",
	"nixd",
	"gopls",
	"zls",
	"dockerls",
	"docker_compose_language_service",
	"pyright",
	"gleam",
	"rust_analyzer",
	"glsl_analyzer",
	"denols",
	"ols",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_init = on_init,
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

-- lspconfig.ols.setup({
-- 	on_init = on_init,
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- 	init_options = {
-- 		enable_format = true,
-- 		enable_hover = true,
-- 		enable_snippets = true,
-- 		enable_semantic_tokens = true,
-- 		enable_document_symbols = true,
-- 		enable_fake_methods = true,
-- 		enable_procedure_snippet = true,
-- 		enable_checker_only_saved = false,
-- 		enable_references = true,
-- 		enable_rename = true,
-- 	},
-- })

lspconfig.lua_ls.setup({
	on_init = on_init,
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

local clangd_path = "clangd"

lspconfig.clangd.setup({
	on_init = on_init,
	on_attach = on_attach,
	capabilities = vim.tbl_extend("keep", capabilities, {
		offsetEncoding = { "utf-16" },
	}),
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
		clangd_path,
		-- "clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
		"--function-arg-placeholders",
		"--fallback-style=llvm",
	},
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
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

local sourcekit_capabilities = vim.tbl_extend("keep", capabilities or {}, {
	workspace = {
		didChangeWatchedFiles = {
			dynamicRegistration = true,
		},
	},
})

lspconfig.sourcekit.setup({
	on_init = on_init,
	on_attach = on_attach,
	capabilities = sourcekit_capabilities,
	filetypes = { "swift" },
})

lspconfig["html"].setup({
	on_attach = on_attach,
	on_init = on_init,
	capabilities = capabilities,
	filetypes = { "html", "vento", "templ" },
	init_options = {
		provideFormatter = false,
	},
})

lspconfig["denols"].setup({
	on_attach = on_attach,
	on_init = on_init,
	capabilities = capabilities,
	root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
	settings = {
		deno = {
			enable = true,
			suggest = {
				imports = {
					hosts = {
						["https://deno.land"] = true,
					},
				},
			},
		},
	},
})

lspconfig.eslint.setup({
	on_init = on_init,
	on_attach = on_attach,
	capabilites = capabilities,
	single_file_support = false,
	root_dir = lspconfig.util.root_pattern(".eslintrc.js", "eslint.config.mjs", ".eslintrc"),
})

lspconfig["ts_ls"].setup({
	root_dir = lspconfig.util.root_pattern("package.json"),
	on_init = on_init,
	on_attach = on_attach,
	single_file_support = false,
	capabilities = capabilities,
	-- settings = {
	-- 	typescript = {
	-- 		inlayHints = {
	-- 			includeInlayParameterNameHints = "literal",
	-- 			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
	-- 			includeInlayFunctionParameterTypeHints = false,
	-- 			includeInlayVariableTypeHints = false,
	-- 			includeInlayPropertyDeclarationTypeHints = false,
	-- 			includeInlayFunctionLikeReturnTypeHints = true,
	-- 			includeInlayEnumMemberValueHints = true,
	-- 		},
	-- 	},
	-- 	javascript = {
	-- 		inlayHints = {
	-- 			includeInlayParameterNameHints = "all",
	-- 			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
	-- 			includeInlayFunctionParameterTypeHints = true,
	-- 			includeInlayVariableTypeHints = true,
	-- 			includeInlayPropertyDeclarationTypeHints = true,
	-- 			includeInlayFunctionLikeReturnTypeHints = true,
	-- 			includeInlayEnumMemberValueHints = true,
	-- 		},
	-- 	},
	-- },
})

-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	callback = function(args)
-- 		local bufnr = args.buf
-- 		local client = vim.lsp.get_client_by_id(args.data.client_id)
-- 		if vim.tbl_contains({ "null-ls" }, client.name) then -- blacklist lsp
-- 			return
-- 		end
-- 		require("lsp_signature").on_attach({
-- 			bind = true,
-- 			handler_opts = {
-- 				border = "rounded",
-- 			},
-- 		}, bufnr)
-- 	end,
-- })

vim.lsp.set_log_level("ERROR")
require("ufo").setup()
