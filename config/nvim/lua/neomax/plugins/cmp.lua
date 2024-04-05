local cmp = require("cmp");

local mapping = {
  ["<Tab>"] = vim.NIL,
  ["<S-Tab>"] = vim.NIL,
  ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
  ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
  ["<C-b>"] = cmp.mapping.scroll_docs(-4),
  ["<C-f>"] = cmp.mapping.scroll_docs(4),
  ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
  ["<C-e>"] = cmp.mapping.abort(), -- close completion window
  ["<CR>"] = cmp.mapping.confirm({ select = false }),
  ["<esc>"] = cmp.mapping({
    i = cmp.mapping.abort(),
    c = function()
      if cmp.visible() then
        cmp.close()
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-C>", true, true, true), "n", true)
      end
    end,
  }),
}

local config = require("nvchad.configs.cmp");

config.mapping = mapping;

return {
	"hrsh7th/nvim-cmp",
  opts = config, 
	config = function(_, opts)
		cmp.setup(opts);
	end,
}
