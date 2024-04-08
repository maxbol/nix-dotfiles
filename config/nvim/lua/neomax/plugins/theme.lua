return {
  "sainnhe/gruvbox-material",
  priority = 1000,
  lazy = false,
  config = function(_, opts)
    -- require("gruvbox-material").setup(opts)
    vim.cmd([[colorscheme gruvbox-material]])
  end
}