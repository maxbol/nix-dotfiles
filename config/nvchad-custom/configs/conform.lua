--type conform.options
local options = {
	lsp_fallback = true,

	formatters_by_ft = {
		nix = { "alejandra" },

		lua = { "stylua" },

		-- typescript = { "prettier" },
		-- javascript = { "prettier" },
		css = { "prettier" },
		html = { "prettier" },

		json = { "fixjson" },

		sh = { "shfmt" },

		go = {
			"gofmt",
			"goimports",
		},
	},

	format_on_save = {
		lsp_fallback = true,
		async = true,
		timeout_ms = 1000,
	},
	-- adding same formatter for multiple filetypes can look too much work for some
	-- instead of the above code you could just use a loop! the config is just a table after all!

	-- format_on_save = {
	--   -- These options will be passed to conform.format()
	--   timeout_ms = 500,
	--   lsp_fallback = true,
	-- },
}

require("conform").setup(options)
