local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

return s(
	"todo",
	fmt("// TODO({date}, {author}): {text}", {
		date = f(function()
			return os.date("%Y-%m-%d")
		end, {}),
		author = f(function()
			local output = vim.fn.system("git config get user.name")
			return output:gsub("\n", "")
		end, {}),
		text = i(0, "Some text"),
	})
)
