local autosave = {}
local config = require("autosave.internal.config")
local log = require("autosave.internal.log")
local events = require("autosave.internal.events")
local commands = require("autosave.internal.commands")

function autosave.setup(opts)
	assert(opts ~= nil, "opts were nil")

	if config.is_set() then
		return log.error("setup() called more than once")
	end

	config.apply(opts)
	local cfg = config.get()

	if cfg.events.register then
		events.register()
	end

	autosave.enabled = true
	autosave.buffers = {}

	require("autosave.internal.events").fire_hook("on_enable")
	commands.init()
end

autosave.enabled = false
return autosave
