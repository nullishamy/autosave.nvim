local log = {}

local function do_log(msg, level)
	vim.notify("[autosave] " .. msg, level, { title = "autosave" })
end

function log.info(msg)
	do_log(msg, vim.log.levels.INFO)
end

function log.warn(msg)
	do_log(msg, vim.log.levels.WARN)
end

function log.error(msg)
	do_log(msg, vim.log.levels.ERROR)
end

return log
