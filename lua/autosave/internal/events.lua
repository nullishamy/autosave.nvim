local events = {}

function events.register()
	local cfg = require("autosave.internal.config").get()
	vim.api.nvim_create_autocmd(cfg.events.triggers, {
		callback = function()
			require("autosave.actions").save()
		end,
	})
end

function events.fire_hook(key)
	local cfg = require("autosave.internal.config").get()

	local hook = cfg.hooks[key]

	if not hook then
		return
	end

	if not type(hook) == "function" then
		return
	end

	hook()
end

return events
