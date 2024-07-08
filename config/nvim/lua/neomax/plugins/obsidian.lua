return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	-- ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	cmd = {
		"ObsidianOpen",
		"ObsidianNew",
		"ObsidianQuickSwitch",
		"ObsidianFollowLink",
		"ObsidianBacklinks",
		"ObsidianTags",
		"ObsidianToday",
		"ObsidianTomorrow",
		"ObsidianYesterday",
		"ObsidianDailies",
		"ObsidianTemplate",
		"ObsidianSearch",
		"ObsidianLink",
		"ObsidianLinkNew",
		"ObsidianLinks",
		"ObsidianExtractNote",
		"ObsidianWorkspace",
		"ObsidianPasteImg",
		"ObsidianRename",
		"ObsidianToggleCheckbox",
	},
	event = {
		-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
		"BufReadPre ~/Notes/maxnotes/**.md",
		"BufNewFile ~/Notes/maxnotes/**.md",
	},
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",

		-- see below for full list of optional dependencies 👇
	},
	opts = {
		daily_notes = {
			-- Optional, if you keep daily notes in a separate directory.
			folder = "Daily agendas",
			-- Optional, if you want to change the date format for the ID of daily notes.
			date_format = "%Y-%m-%d",
			-- Optional, default tags to add to each new daily note created.
			default_tags = { "daily-notes" },
			-- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
			template = "Agenda.md",
		},
		templates = {
			folder = "~/Notes/maxnotes/Templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
			-- A map for custom variables, the key should be the variable and the value a function
			substitutions = {},
		},
		workspaces = {
			{
				name = "Personal",
				path = "~/Notes/maxnotes",
			},
		},
		note_id_func = function(title)
			-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
			-- In this case a note with the title 'My new note' will be given an ID that looks
			-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
			local suffix = ""
			if title ~= nil then
				-- If title is given, transform it into valid file name.
				suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			else
				-- If title is nil, just add 4 random uppercase letters to the suffix.
				for _ = 1, 4 do
					suffix = suffix .. string.char(math.random(65, 90))
				end
			end
			return tostring(os.time()) .. "-" .. suffix
		end,
	},
}
