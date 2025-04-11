return {
	{
		dir = "~/.config/nvim/lua/neomax/color",
		init = function()
			require("neomax.color")
		end,
		lazy = false,
		priority = 1000,
		dependencies = {
			-- Lualine
			"nvim-tree/nvim-web-devicons",
			"Tronikelis/lualine-components.nvim",
			{
				"nvim-lualine/lualine.nvim",
				config = function()
					require("lualine").setup({
						theme = "auto",
						sections = {
							lualine_a = { "mode" },
							lualine_b = {
								"branch",
								"diff",
								"diagnostics",
							},
							lualine_c = { require("lualine-components.filename-oil") },
							lualine_x = { "encoding", "fileformat", "filetype" },
							lualine_y = { "progress" },
							lualine_z = { "location" },
						},
						inactive_sections = {
							lualine_a = {},
							lualine_b = {},
							lualine_c = { "filename" },
							lualine_x = { "location" },
							lualine_y = {},
							lualine_z = {},
						},
					})
				end,
			},

			-- Themes
			-- {
			--
			{
				"yorik1984/newpaper.nvim",
			},
			{
				"letorbi/vim-colors-modern-borland",
				config = function()
					vim.g.BorlandStyle = "modern"
					vim.g.BorlandParen = 1
				end,
			},
			{
				"Shatur/neovim-ayu",
				config = function()
					require("ayu").setup({
						terminal = false,
						-- transparent mode:
						overrides = {
							Normal = { bg = "None" },
							ColorColumn = { bg = "None" },
							SignColumn = { bg = "None" },
							Folded = { bg = "None" },
							FoldColumn = { bg = "None" },
							CursorLine = { bg = "None" },
							CursorColumn = { bg = "None" },
							WhichKeyFloat = { bg = "None" },
							VertSplit = { bg = "None" },
						},
					})
				end,
			},
			{
				"scottmckendry/cyberdream.nvim",
			},
			{
				"Yazeed1s/oh-lucy.nvim",
			},
			{ "savq/melange-nvim" },
			{
				"olivercederborg/poimandres.nvim",
				config = function()
					require("poimandres").setup({
						-- leave this setup function empty for default config
						-- or refer to the configuration section
						-- for configuration options
					})
				end,
			},
			{
				"blazkowolf/gruber-darker.nvim",
				opts = {
					undercurl = true,
					underline = true,
				},
			},
			{
				"kvrohit/rasmus.nvim",
				config = function()
					vim.g.rasmus_transparent = true
				end,
			},
			{
				"zenbones-theme/zenbones.nvim",
				-- Optionally install Lush. Allows for more configuration or extending the colorscheme
				-- If you don't want to install lush, make sure to set g:zenbones_compat = 1
				-- In Vim, compat mode is turned on as Lush only works in Neovim.
				dependencies = { "rktjmp/lush.nvim" },
			},
			{
				"sainnhe/gruvbox-material",
				config = function(_, opts)
					vim.g.gruvbox_material_background = "medium" -- hard, medium, soft
					vim.g.gruvbox_material_transparent_background = 1
				end,
			},
			{
				"vague2k/vague.nvim",
				config = function()
					require("vague").setup({
						transparent = true,
						-- optional configuration here
					})
				end,
			},
			{
				"uloco/bluloco.nvim",
				dependencies = { "rktjmp/lush.nvim" },
				config = function()
					require("bluloco").setup({
						style = "auto", -- "auto" | "dark" | "light"
						transparent = true,
						-- transparent = true,
						italics = false,
						terminal = vim.fn.has("gui_running") == 1, -- bluoco colors are enabled in gui terminals per default.
						guicursor = true,
					})
				end,
			},
			{
				"rebelot/kanagawa.nvim",
				config = function()
					require("kanagawa").setup({
						compile = false, -- enable compiling the colorscheme
						undercurl = true, -- enable undercurls
						commentStyle = { italic = true },
						functionStyle = {},
						keywordStyle = { italic = true },
						statementStyle = { bold = true },
						typeStyle = {},
						transparent = true, -- do not set background color
						dimInactive = true, -- dim inactive window `:h hl-NormalNC`
						terminalColors = true, -- define vim.g.terminal_color_{0,17}
						colors = { -- add/modify theme and palette colors
							palette = {},
							theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
						},
						overrides = function(colors) -- add/modify highlights
							return {}
						end,
						theme = "wave", -- Load "wave" theme when 'background' option is not set
						background = { -- map the value of 'background' option to a theme
							dark = "wave", -- try "dragon" !
							light = "lotus",
						},
					})
				end,
			},
			{
				"folke/tokyonight.nvim",
				config = function()
					require("tokyonight").setup({
						style = "night",
						transparent = true,
					})
				end,
			},
			{
				"diegoulloao/neofusion.nvim",
				config = function()
					require("neofusion").setup({
						terminal_colors = true,
						transparent_mode = true,
					})
				end,
			},
			{
				"catppuccin/nvim",
				name = "catppuccin",
				config = function()
					require("catppuccin").setup({
						flavour = "mocha",
						transparent_background = true,
						integrations = {
							cmp = true,
							gitsigns = true,
							treesitter = true,
							neotest = true,
							dap = true,
							dap_ui = true,
							octo = true,
							lsp_trouble = true,
							diffview = true,
						},
					})
				end,
			},
			{
				"rose-pine/neovim",
				name = "rose-pine",
				config = function()
					require("rose-pine").setup({
						variant = "main", -- auto, main, moon, or dawn
						dark_variant = "main", -- main, moon, or dawn
						-- dim_inactive_windows = true,
						extend_background_behind_borders = true,

						enable = {
							terminal = true,
							legacy_highlights = false, -- Improve compatibility for previous versions of Neovim
							migrations = true, -- Handle deprecated options automatically
						},

						styles = {
							bold = true,
							italic = true,
							transparency = true,
						},

						groups = {
							border = "muted",
							link = "iris",
							panel = "surface",

							error = "love",
							hint = "iris",
							info = "foam",
							note = "pine",
							todo = "rose",
							warn = "gold",

							git_add = "foam",
							git_change = "rose",
							git_delete = "love",
							git_dirty = "rose",
							git_ignore = "muted",
							git_merge = "iris",
							git_rename = "pine",
							git_stage = "iris",
							git_text = "rose",
							git_untracked = "subtle",

							h1 = "iris",
							h2 = "foam",
							h3 = "rose",
							h4 = "gold",
							h5 = "pine",
							h6 = "foam",
						},

						highlight_groups = {
							LspSignatureActiveParameter = { bg = "pine" },
							-- CursorLine = { bg = "pine" },
							-- Visual = { bg = "pine" },
							-- Comment = { fg = "foam" },
							-- VertSplit = { fg = "muted", bg = "muted" },
						},

						before_highlight = function(group, highlight, palette)
							-- Disable all undercurls
							-- if highlight.undercurl then
							--     highlight.undercurl = false
							-- end
							--
							-- Change palette colour
							-- if highlight.fg == palette.pine then
							--     highlight.fg = palette.foam
							-- end
						end,
					})
				end,
			},
			{
				"sho-87/kanagawa-paper.nvim",
				lazy = false,
				priority = 1000,
				opts = {},
			},
			{
				"baliestri/aura-theme",
				lazy = false,
				priority = 1000,
				config = function(plugin)
					vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
				end,
			},
			"sainnhe/everforest",
			{
				"shaunsingh/nord.nvim",
				lazy = false,
			},
		},
	},
}
