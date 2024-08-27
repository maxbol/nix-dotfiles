local options = {
	formatters_by_ft = {
		nix = { "alejandra" },

		lua = { "stylua" },

		-- typescript = { "prettier" },
		-- javascript = { "prettier" },
		css = { "prettier" },
		html = { "prettier" },
		graphql = { "prettier" },

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
