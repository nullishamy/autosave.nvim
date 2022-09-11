local commands = {}

function commands.init()
	vim.cmd [[
		command! ASGlobalEnable    lua require('autosave.actions').global_enable()
		command! ASGlobalDisable   lua require('autosave.actions').global_disable()
		command! ASGlobalToggle    lua require('autosave.actions').global_toggle()
		
		command! ASEnable   lua require('autosave.actions').buf_enable()
		command! ASDisable  lua require('autosave.actions').buf_disable()
		command! ASToggle   lua require('autosave.actions').buf_toggle()

		command! ASStatus   lua require('autosave.actions').show_status()
	]]
end

return commands
