local actions = {}
local as = require("autosave")

-- Tracks which buffers are currently scheduled to bounce
-- True means that we're currently scheduled to save, false means we are not
local debounce_bufs = {}

local function handle_save(cfg)
	local buf = vim.api.nvim_get_current_buf()

	local function do_save()
		require("autosave.events").fire_hook("pre_write")
		-- If any filter fails, abort
		for _, cond in pairs(cfg.filters) do
			if not cond(buf) then
				return
			end
		end

		vim.api.nvim_buf_call(buf, function()
			vim.cmd("write")
		end)
		require("autosave.events").fire_hook("post_write")
	end

	if cfg.debounce.enabled then
		if debounce_bufs[buf] then
			-- We're debouncing, don't write
			return
		end

		vim.defer_fn(function()
			-- We saved, cancel the state and allow for more writes
			debounce_bufs[buf] = false
			do_save()
		end, cfg.debounce.delay)

		-- Set the state, we're debouncing now
		debounce_bufs[buf] = true
	else
		-- We dont want to debounce, save immediately
		do_save()
	end
end

function actions.save()
	local cfg = require("autosave.config").get()

	if not as.enabled then
		return
	end

	handle_save(cfg)
end

function actions.enable()
	as.enabled = true
end

function actions.disable()
	as.enabled = false
end

function actions.toggle()
	if as.enabled then
		as.enabled = false
	else
		as.enabled = true
	end
end

return actions
