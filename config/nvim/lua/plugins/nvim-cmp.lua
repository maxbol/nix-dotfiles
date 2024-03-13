return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer", -- suggestions from current buffer
		"hrsh7th/cmp-path", -- suggestions for file paths
		"onsails/lspkind.nvim",
		"L3MON4D3/LuaSnip", -- snippet engine
		"saadparwaiz1/cmp_luasnip", -- for autocompletion
		"rafamadriz/friendly-snippets", -- useful database of snippets
	},
	config = function()
		-- load dependencies
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")

		-- load vscode-like snippets from all the plugins
		require("luasnip.loaders.from_vscode").lazy_load()

		vim.opt.completeopt = "menu,menuone,noselect"
		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
				["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<esc>"] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = function()
            if cmp.visible() then
              cmp.close()
            else
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-C>', true, true, true), 'n', true)
            end
          end
        }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" }, -- lsp
				{ name = "nvim_lsp_signature_help" }, -- lsp signatures
				{ name = "luasnip" }, -- snippets
				{ name = "buffer" }, -- text within current buffer
				{ name = "path" }, -- file system paths
			}),
			formatting = {
				format = lspkind.cmp_format({
					maxwidth = 50,
					ellipsis_char = "...",
				}),
			},
			window = {
				completion = {
					border = "rounded",
					winhighlight = "FloatBorder:FloatBorder,Normal:Normal",
				},
				documentation = {
					border = "rounded",
					winhighlight = "FloatBorder:FloatBorder,Normal:Normal",
				},
			},
		})

		luasnip.config.set_config({
			-- Keep around the last snippet
			history = true,
			-- Dynamically update snippets as you type
			updateevents = "TextChanged, TextChangedI",
			-- Autosnippets
			enable_autosnippets = true,
		})

		-- snippet keymaps
		local keymap = vim.keymap

		-- keymap to jump forward
		vim.keymap.set({ "i", "s" }, "<c-l>", function()
			if luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			end
		end, { silent = true })

		-- keymap to jump backwards
		vim.keymap.set({ "i", "s" }, "<c-h>", function()
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			end
		end, { silent = true })
	end,
}
