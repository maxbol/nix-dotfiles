local configs = require("nvchad.configs.lspconfig")

local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities

local lspconfig = require("lspconfig")

-- if you just want default config for the servers then put them in a table
local servers = {
	"html",
	"cssls",
	"clangd",
	"bufls",
	"tsserver",
	-- "eslint",
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

lspconfig["eslint"].setup({
	on_init,
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			command = "EslintFixAll",
		})
	end,
	capabilities = capabilities,
})

vim.lsp.set_log_level("ERROR")

-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	callback = function()
-- 		print("what")
-- 		vim.lsp.buf.format()
-- 	end,
-- })
-- -- lspconfig["gopls"].setup({
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- })

--
-- lspconfig.pyright.setup { blabla}
