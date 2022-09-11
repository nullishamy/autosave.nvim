local actions = {}
local as = require("autosave")

-- Tracks which buffers are currently scheduled to bounce
-- True means that we're currently scheduled to save, false means we are not
local debounce_bufs = {}

local function handle_save(cfg)
	local buf = vim.api.nvim_get_current_buf()

	local function do_save()
		require("autosave.internal.events").fire_hook("pre_filter")
		-- If any filter fails, abort
		for _, cond in pairs(cfg.filters) do
			if not cond(buf) then
				return
			end
		end

		require("autosave.internal.events").fire_hook("pre_write")

		vim.api.nvim_buf_call(buf, function()
			vim.cmd("silent write" .. (cfg.plugin.force and "!" or ""))
		end)

		require("autosave.internal.events").fire_hook("post_write")
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
	local cfg = require("autosave.internal.config").get()

	if not as.enabled then
		return
	end

	handle_save(cfg)
end

function actions.buf_enable()
	local buf = vim.api.nvim_get_current_buf()
	as.buffers[buf] = true
end

function actions.buf_disable()
	local buf = vim.api.nvim_get_current_buf()
	as.buffers[buf] = false
end

function actions.buf_toggle()
	local buf = vim.api.nvim_get_current_buf()
	local buf_is_enabled = as.buffers[buf]

	if not buf_is_enabled then
		-- Value is false or non existent
		as[buf] = true
	else
		as[buf] = false
	end
end

function actions.global_enable()
	as.enabled = true
end

function actions.global_disable()
	as.enabled = false
end

function actions.global_toggle()
	if as.enabled then
		as.enabled = false
	else
		as.enabled = true
	end
end

function actions.show_status()
	local buf = vim.api.nvim_get_current_buf()
	local buf_is_enabled = as.buffers[buf]

	if buf_is_enabled == nil then
		-- Default true
		buf_is_enabled = true
	end

	print(
		string.format(
			"AutoSave: global_enabled=%s buf_enabled=%s util.buf_enabled=%s",
			as.enabled,
			buf_is_enabled,
			require("autosave.util").buf_enabled(buf)
		)
	)
end

return actions
