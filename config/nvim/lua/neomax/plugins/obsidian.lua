return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	cmd = {
		"ObsidianOpen",
		"ObisidanNew",
		"ObsidianQuickSwitch",
		"ObsidianFollowLink",
		"ObsidianBacklinks",
		"ObsidianTags",
		"ObsidianToday",
		"ObisidanYesterday",
		"ObsidianTomorrow",
		"ObsidianDailies",
		"ObsidianTemplate",
		"ObsidianSearch",
		"ObsidianLink",
		"ObsidianLinkNew",
		"ObsidianLinks",
		"ObsidianExtractNote",
		"ObsidianPasteImg",
		"ObsidianRename",
		"ObsidianToggleCheckbox",
	},
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
	--   "BufReadPre path/to/my-vault/**.md",
	--   "BufNewFile path/to/my-vault/**.md",
	-- },
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",

		-- see below for full list of optional dependencies 👇
	},
	opts = {
		workspaces = {
			{
				name = "Personal Notes",
				path = "~/Notes/Personal Notes/Personal Notes/",
			},
		},

		daily_notes = {
			-- Optional, if you keep daily notes in a separate directory.
			folder = "Daily agendas",
			-- Optional, if you want to change the date format for the ID of daily notes.
			date_format = "%Y-%m-%d",
			-- Optional, if you want to change the date format of the default alias of daily notes.
			alias_format = "%Y-%m-%d",
			-- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
			template = "Agenda.md",
		},
		templates = {
			subdir = "Templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
			-- A map for custom variables, the key should be the variable and the value a function
			substitutions = {},
		},
		-- see below for full list of options 👇
	},
}
