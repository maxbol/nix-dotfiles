---@type ChadrcConfig
local M = {}
local getUi = require("ui")
M.ui = getUi(require("custom.highlights"))
M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require("custom.mappings")

return M
