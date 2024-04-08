local on_attach = function(client, bufnr)
	local function opts(desc)
		return { buffer = bufnr, desc = desc }
	end

	map("n", "gD", vim.lsp.buf.declaration, opts("Lsp Go to declaration"))
	map("n", "gd", vim.lsp.buf.definition, opts("Lsp Go to definition"))
	map("n", "K", vim.lsp.buf.hover, opts("Lsp hover information"))
	map("n", "gi", vim.lsp.buf.implementation, opts("Lsp Go to implementation"))
	map("n", "<leader>sh", vim.lsp.buf.signature_help, opts("Lsp Show signature help"))
	map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Lsp Add workspace folder"))
	map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Lsp Remove workspace folder"))

	map("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts("Lsp List workspace folders"))

	map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Lsp Go to type definition"))

	-- map("n", "<leader>ra", function()
	--   require "nvchad.lsp.renamer"()
	-- end, opts "Lsp NvRenamer")

	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Lsp Code action"))
	map("n", "gr", vim.lsp.buf.references, opts("Lsp Show references"))
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
	"tsserver",
	"eslint",
	"nixd",
	"gopls",
}

-- lspconfig["eslint"].setup({
-- 	on_init = on_init,
-- 	on_attach = function(client, bufnr)
-- 		on_attach(client, bufnr)
-- 		vim.api.nvim_create_autocmd("BufWritePre", {
-- 			buffer = bufnr,
-- 			command = "EslintFixAll",
-- 		})
-- 	end,
-- 	capabilities = capabilities,
-- })

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_init = on_init,
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

vim.lsp.set_log_level("ERROR")

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		vim.lsp.buf.format()
	end,
})
-- -- lspconfig["gopls"].setup({
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- })

--
-- lspconfig.pyright.setup { blabla}
