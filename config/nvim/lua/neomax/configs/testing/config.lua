local suites = require("neomax.configs.testing.suites")
local opts = require("neomax.configs.testing.opts")
return function()
	local adapters = {}
	for i, v in ipairs(suites) do
		if v.init ~= nil then
			v.init()
		end

		if v.setup ~= nil then
			opts = v.setup(opts)
		end

		if v.adapter ~= nil then
			table.insert(adapters, v.adapter())
		end
	end

	opts.adapters = adapters

	require("neotest").setup(opts)
end
