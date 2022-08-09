local filters = {}
local util = require('autosave.util')

--- API NOTE
--- If filters return false, execution halts

--- Require that the current workspace is a git directory
---@return boolean
function filters.git_repo()
	local ok, _ = util.execute_command({ 'git', 'rev-parse', '--is-inside-work-tree' })
	return ok
end

--- Inverts the given `filter`
---@param filter function The filter to invert
---@return function
function filters.invert(filter)
	local inner_not = function(...)
		return not filter(...)
	end

	return inner_not
end

--- Require that the buffer has the option with key `key` set to `value`
---@param key string The key to use
---@param value unknown The value to check against
---@return function
function filters.opt(key, value)
	local inner_opt = function(bufnr)
		return vim.api.nvim_buf_get_option(bufnr, key) == value
	end

	return inner_opt
end

--- Require that the buffer is not empty, that it has more than 0 lines
---@param bufnr integer The buffer to check
---@return boolean
function filters.not_empty(bufnr)
	return vim.api.nvim_buf_line_count(bufnr) > 0
end

--- Require that the buffer is modifiable, that is has the `modifiable` option set
---@param bufnr integer The buffer to check
---@return boolean
function filters.modifiable(bufnr)
	return filters.opt("modifiable", true)(bufnr)
end

--- Require that the buffer is writeable:
--- 1) It is loaded and valid according to nvim. This means it can be read.
--- 2) It has no buftype set. buftype indicates it is not a regular buffer than can be written
--- 3) It has a filename set
---@param bufnr integer The buffer to check
---@return boolean
function filters.writeable(bufnr)
	return vim.api.nvim_buf_is_loaded(bufnr) and filters.opt("buftype", "")(bufnr) and string.len(vim.api.nvim_buf_get_name(0)) > 0
end

--- Require that the buffer has been modified, that is has the `modified` option set
---@param bufnr integer The buffer to check
---@return boolean
function filters.modified(bufnr)
	return filters.opt("modified", true)(bufnr)
end

--- Require that the buffer's filetype does not match `ft`.
---@param ft string The filetype to filter
---@return function
function filters.filetype(ft)
	local function inner_ignore(bufnr)
		return not filters.opt("filetype", ft)(bufnr)
	end

	return inner_ignore
end

--- Requires that the callback function returns `true`
--- Type: function(bufnr: string)
---@param cb function The callback
function filters.custom(cb)
	local inner_custom = function(bufnr)
		local ok, res = pcall(cb, bufnr)
		if not ok then
			require("autosave.internal.log").error(string.format("error occured in custom callback %s", res))
			return false
		end

		return res
	end

	return inner_custom
end

return filters
