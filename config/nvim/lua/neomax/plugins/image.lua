local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set

return {
	{
		-- Use my own fork of image.nvim until my PR is merged
		-- https://github.com/3rd/image.nvim/pull/221
		"maxbol/image.nvim",
		branch = "pr-199@tmux-session-agnostic-status-getters",
		-- "3rd/image.nvim",
		-- branch = "master",
		dependencies = { "luarocks.nvim" },
		lazy = false,
		filetypes = { "markdown", "vimwiki", "nofile", "image", "jpg", "png", "gif", "webp" },
		config = function()
			local image = require("image")
			image.setup({
				backend = "kitty",
				integrations = {
					markdown = {
						enabled = true,
						clear_in_insert_mode = true,
						download_remote_images = true,
						only_render_image_at_cursor = true,
						filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
					},
					neorg = {
						enabled = true,
						clear_in_insert_mode = false,
						download_remote_images = true,
						only_render_image_at_cursor = false,
						filetypes = { "norg" },
					},
					html = {
						enabled = true,
					},
					css = {
						enabled = false,
					},
				},
				max_width = 5000,
				max_height = 5000,
				max_width_window_percentage = 100,
				max_height_window_percentage = 100,
				window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
				window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
				editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
				tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
				hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" }, -- render image files as images when opened
			})

			local image_resize_keymap = augroup("ImageResizeKeymap", { clear = true })
			autocmd("BufRead", {
				group = image_resize_keymap,
				callback = function(o)
					local bufnr = o.buf
					local images = image.get_images({ buffer = bufnr })
					if #images ~= 1 then
						return
					end

					local preview_image = images[1]

					map("n", "+", function()
						preview_image.image_width = preview_image.image_width * 1.25
						preview_image.image_height = preview_image.image_height * 1.25
						preview_image:render()
					end, {
						buffer = bufnr,
						desc = "Zoom in image",
					})

					map("n", "_", function()
						preview_image.image_width = preview_image.image_width / 1.25
						preview_image.image_height = preview_image.image_height / 1.25
						preview_image:render()
					end, {
						buffer = bufnr,
						desc = "Zoom out image",
					})
				end,
			})
		end,
	},
}
