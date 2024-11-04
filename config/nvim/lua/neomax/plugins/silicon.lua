local function get_theme_path()
	local active_bat_path = vim.env.HOME .. "/.config/chroma/active/bat/config"

	if vim.fn.filereadable(active_bat_path) == 0 then
		print("Woops! " .. active_bat_path .. " does not exist!")
		return nil
	end

	local batargs = vim.fn.readfile(active_bat_path)
	local battheme = batargs[1]:match("--theme=(.+)")

	if battheme == nil then
		return nil
	end

	local themeroot = vim.env.HOME .. "/.config/bat/themes"
	local themepath = themeroot .. "/" .. battheme .. ".tmTheme"
	print("Theme path: " .. themepath)
	return themepath
end

return {
	"michaelrommel/nvim-silicon",
	lazy = true,
	cmd = "Silicon",
	build = "./install.sh",
	config = function()
		require("silicon").setup({
			-- Configuration here, or leave empty to use defaults
			font = "Hack=34",
			to_clipboard = true,
			theme = get_theme_path(),
		})
	end,
}
