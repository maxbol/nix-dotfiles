return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	dependencies = {
		"saghen/blink.cmp",
	},
	opts = {
		check_ts = true,
		fast_wrap = {},
		disable_filetype = { "TelescopePrompt", "vim" },
	},
}
