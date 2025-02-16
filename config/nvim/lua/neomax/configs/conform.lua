local options = {
	formatters_by_ft = {
		nix = { "alejandra" },

		lua = { "stylua" },

		-- typescript = { "prettier" },
		-- javascript = { "prettier" },
		css = { "prettier" },
		graphql = { "prettier" },
		html = { "prettier_html" },
		vento = { "prettier_html" },
		templ = { "prettier_html" },

		json = { "fixjson" },

		sh = { "shfmt" },

		go = {
			"gofmt",
			"goimports",
		},

		cs = {
			"csharpier",
		},

		-- sql = {
		-- 	"sqlfluff",
		-- },
		-- css = { "prettier" },
		-- html = { "prettier" },
	},

	formatters = {
		prettier_html = {
			command = "prettier",
			args = {
				"--parser",
				"html",
			},
		},
		csharpier = {
			command = "dotnet-csharpier",
			args = {
				"--write-stdout",
			},
		},
		sqlfluff = {
			command = "sqlfluff",
			args = {
				"fix",
				"--disable-progress-bar",
				"-f",
				"-n",
				"-",
			},
			stdin = true,
		},
	},

	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_fallback = true,
	},
}

require("conform").setup(options)
