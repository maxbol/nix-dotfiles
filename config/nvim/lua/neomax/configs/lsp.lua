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

	--map("n", "K", vim.lsp.buf.hover, opts("Lsp hover information"))
	map("n", "K", "<cmd>Lspsaga hover_doc<CR>")

	map("n", "gi", vim.lsp.buf.implementation, opts("Lsp Go to implementation"))
	map("n", "<leader>sh", vim.lsp.buf.signature_help, opts("Lsp Show signature help"))
	map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Lsp Add workspace folder"))
	map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Lsp Remove workspace folder"))

	map("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts("Lsp List workspace folders"))

	map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Lsp Go to type definition"))

	-- map("n", "<leader>ra", function()
	-- 	require("neomax.modules.lsp.renamer")()
	-- end, opts("Lsp NvRenamer"))
	map("n", "<leader>ra", "<cmd>Lspsaga rename ++project<CR>", opts("Rename code symbol"))

	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Lsp Code action"))
	-- map("n", "gr", vim.lsp.buf.references, opts("Lsp Show references"))
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

	-- if client.server_capabilities.signatureHelpProvider then
	-- 	require("neomax.modules.lsp.signature")
	-- end
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

local lspconfig = require("lspconfig")

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
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_init = on_init,
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

-- lspconfig["eslint"].setup({
-- 	on_init = on_init,
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- 	settings = {
-- 		eslint = {
-- 			autoFixOnSave = true,
-- 		},
-- 	},
-- })

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

vim.lsp.set_log_level("ERROR")

-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	callback = function()
-- 		vim.lsp.buf.format()
-- 	end,
-- })
-- -- lspconfig["gopls"].setup({
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- })

--
-- lspconfig.pyright.setup { blabla}
