local commands = {}

function commands.init()
	vim.cmd [[
		command! ASEnable   lua require('autosave.actions').enable()
		command! ASDisable  lua require('autosave.actions').disable()
		command! ASToggle   lua require('autosave.actions').toggle()
		command! ASSTatus   lua require('autosave.actions').show_status()
	]]
end

return commands
