-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
--
vim.lsp.set_log_level("debug")

vim.g.markdown_recommended_style = 0

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_execute_on_save = 1
vim.g.completion_matching_strategy_list = { "exact", "substring" }
vim.g.completion_matching_ignore_case = 1

vim.opt.relativenumber = true
