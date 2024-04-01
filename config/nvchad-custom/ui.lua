local highlights = require("custom.highlights")

local M = {
	theme = "gruvchad",
	theme_toggle = { "gruvchad", "gruvbox_light" },

	hl_override = highlights.override,
	hl_add = highlights.add,
}

return M
