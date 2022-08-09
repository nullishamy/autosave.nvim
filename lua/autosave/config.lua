local tbl = require("plenary.tbl")

local filters = require("autosave.filters")
local DEFAULTS = {
	events = {
		register = true,
		triggers = {
			"InsertLeave",
			"TextChanged",
		},
	},
	debounce = {
		delay = 250,
		enabled = true,
	},
	filters = {
		filters.writeable,
		filters.not_empty,
		filters.modified,
	},
	hooks = {
		on_enable = nil,
		pre_write = nil,
		post_write = nil,
	},
}

local config = {}

local function is_set()
	return config.data ~= nil
end

local function get()
	assert(is_set(), "config was not set, call apply first")
	return config.data
end

local function apply(opts)
	assert(opts ~= nil, "config opts were nil")

	-- This is probably a bug if this happens
	assert(not is_set(), "attempted to set config more than once")

	config.data = vim.deepcopy(opts)
	config.data = tbl.apply_defaults(config.data, DEFAULTS)
	return get()
end

return {
	apply = apply,
	get = get,
	is_set = is_set,
	defaults = DEFAULTS,
}
