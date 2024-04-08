local options = {
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
		-- css = { "prettier" },
		-- html = { "prettier" },
	},

	format_on_save = {
	  -- These options will be passed to conform.format()
	  timeout_ms = 500,
	  lsp_fallback = true,
	},
}

require("conform").setup(options)
