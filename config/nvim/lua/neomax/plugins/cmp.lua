return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		{
			-- snippet plugin
			"L3MON4D3/LuaSnip",
			dependencies = "rafamadriz/friendly-snippets",
			opts = { history = true, updateevents = "TextChanged,TextChangedI" },
			config = function(_, opts)
				require("luasnip").config.set_config(opts)
				require("luasnip.loaders.from_vscode").lazy_load()
				require("luasnip").add_snippets("all", {
					require("neomax.configs.snippets.todo"),
				})
			end,
		},

		-- autopairing of (){}[] etc
		{
			"windwp/nvim-autopairs",
			opts = {
				check_ts = true,
				fast_wrap = {},
				disable_filetype = { "TelescopePrompt", "vim" },
			},
			config = function(_, opts)
				require("nvim-autopairs").setup(opts)

				-- setup cmp for autopairs
				local cmp_autopairs = require("nvim-autopairs.completion.cmp")
				require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end,
		},

		-- cmp sources plugins
		{
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"vim-dadbod-completion",
		},
	},
	config = function(_, opts)
		local cmp = require("cmp")

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			completion = {
				completeopt = "menu,menuone",
			},
			mapping = cmp.mapping.preset.insert({
				["<Tab>"] = vim.NIL,
				--     cmp.mapping(function(fallback)
				-- 	local copilot_keys = vim.fn["copilot#Accept"]()
				-- 	if copilot_keys ~= "" then
				-- 		vim.api.nvim_feedkeys(copilot_keys, "i", true)
				-- 	else
				-- 		fallback()
				-- 	end
				-- 	-- if luasnip.expand_or_jumpable() then
				-- 	-- 	luasnip.expand_or_jump()
				-- 	-- else
				-- 	-- 	fallback()
				-- 	-- end
				-- end, { "i", "s" }),
				["<S-Tab>"] = vim.NIL,
				-- ["<S-Tab>"] = cmp.mapping(function(fallback)
				-- 	if luasnip.jumpable(-1) then
				-- 		luasnip.jump(-1)
				-- 	else
				-- 		fallback()
				-- 	end
				-- end, { "i", "s" }),
				-- ["<Tab>"] = vim.NIL,
				-- ["<S-Tab>"] = vim.NIL,
				["<C-j>"] = cmp.mapping(function(fallback)
					local luasnip = require("luasnip")
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<C-k>"] = cmp.mapping(function(fallback)
					local luasnip = require("luasnip")
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
				-- ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				-- ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
				["<CR>"] = cmp.mapping.confirm({ select = false }),
				-- ["<esc>"] = cmp.mapping({
				-- 	i = function()
				-- 		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-C>", true, true, true), "n", true)
				-- 	end,
				-- 	c = function()
				-- 		--[[ if cmp.visible() then
				-- 			cmp.close()
				-- 		else ]]
				-- 		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-C>", true, true, true), "n", true)
				-- 		-- end
				-- 	end,
				-- }),
			}),
			sources = cmp.config.sources({
				{ name = "luasnip" },
				{ name = "nvim_lsp" },
				{ name = "buffer" },
				{ name = "nvim_lua" },
				{ name = "path" },
			}),
		})
	end,
}
