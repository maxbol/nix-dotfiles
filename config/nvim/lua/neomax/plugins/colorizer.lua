return {
	"norcalli/nvim-colorizer.lua",
	config = function()
		require("colorizer").setup()

		-- Seems to be required for sessioln restore
		vim.defer_fn(function()
			vim.cmd("ColorizerAttachToBuffer")
		end, 0)

		local group = vim.api.nvim_create_augroup("ColorizerAttachOnBufEnter", {
			clear = true,
		})

		vim.api.nvim_create_autocmd("BufEnter", {
			group = group,
			callback = function()
				vim.cmd("ColorizerAttachToBuffer")
			end,
		})
	end,
	-- lazy = false,
	event = { "VeryLazy" },
}
