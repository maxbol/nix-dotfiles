-- if vim.fn.has("macunix") == 1 then
return {
	-- {
	-- 	"nyoom-engineering/oxocarbon.nvim",
	-- 	lazy = false,
	-- 	config = function()
	-- 		vim.opt.background = "dark" -- set this to dark or light
	-- 		vim.cmd("colorscheme oxocarbon")
	-- 	end,
	-- 	-- Add in any other configuration;
	-- 	--   event = foo,
	-- 	--   config = bar
	-- 	--   end,
	-- },
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		config = function()
			require("rose-pine").setup({
				variant = "main", -- auto, main, moon, or dawn
				dark_variant = "main", -- main, moon, or dawn
				dim_inactive_windows = true,
				extend_background_behind_borders = true,

				enable = {
					terminal = true,
					legacy_highlights = false, -- Improve compatibility for previous versions of Neovim
					migrations = true, -- Handle deprecated options automatically
				},

				styles = {
					bold = true,
					italic = true,
					transparency = false,
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
			vim.cmd("colorscheme rose-pine")
		end,
	},
	-- {
	-- 	"catppuccin/nvim",
	-- 	name = "catppuccin",
	-- 	priority = 2000,
	-- 	lazy = false,
	-- 	config = function()
	-- 		vim.cmd([[colorscheme catppuccin-mocha]])
	-- 		require("catppuccin").setup({
	-- 			flavour = "mocha",
	-- 			integrations = {
	-- 				cmp = true,
	-- 				gitsigns = true,
	-- 				treesitter = true,
	-- 				neotest = true,
	-- 				dap = true,
	-- 				dap_ui = true,
	-- 				octo = true,
	-- 				lsp_trouble = true,
	-- 				diffview = true,
	-- 			},
	-- 		})
	-- 	end,
	-- },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "Tronikelis/lualine-components.nvim" },
		lazy = false,
		config = function()
			require("lualine").setup({
				options = {
					theme = "rose-pine",
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { require("lualine-components.branch-oil"), "diff", "diagnostics" },
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
}
-- end

-- return {
-- 	{
-- 		"sainnhe/gruvbox-material",
-- 		priority = 1000,
-- 		lazy = false,
-- 		config = function(_, opts)
-- 			vim.opt.background = "dark" -- dark, light
-- 			vim.g.gruvbox_material_background = "medium" -- hard, medium, soft
-- 			vim.g.gruvbox_material_transparent_background = 1
--
-- 			vim.cmd([[colorscheme gruvbox-material]])
--
-- 			vim.cmd([[hi CursorLine guibg=#427b58]])
-- 			vim.cmd([[hi Visual guibg=#427b58]])
-- 			vim.cmd([[hi TelescopeSelection guibg=#427b58]])
-- 			vim.cmd([[hi NotifyBackground guibg=#504945]])
-- 		end,
-- 	},
-- 	{
-- 		"nvim-lualine/lualine.nvim",
-- 		dependencies = { "nvim-tree/nvim-web-devicons" },
-- 		lazy = false,
-- 		config = function()
-- 			require("lualine").setup({
-- 				options = {
-- 					theme = "gruvbox-material",
-- 				},
-- 			})
-- 		end,
-- 	},
-- }
