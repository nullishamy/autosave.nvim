local util = {}

function util.execute_command(cmd)
	local result = vim.fn.systemlist(cmd)

	-- An empty result is ok
	if vim.v.shell_error ~= 0 or (#result > 0 and vim.startswith(result[1], "fatal:")) then
		return false, {}
	else
		return true, result
	end
end

function util.buf_enabled(bufnr)
	local as = require('autosave')

	-- If the buffer is disabled, or the plugin is globally disabled, return false
	local buf = as.buffers[bufnr]
	if buf == false then
		return false
	end

	return as.enabled
end

return util
