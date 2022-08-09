local autosave = { }
local config = require('autosave.config')
local log = require('autosave.log')
local events = require('autosave.events')

function autosave.setup(opts)
    assert(opts ~= nil, 'opts were nil')
    if config.is_set() then
        return log.error('setup() called more than once')
    end

    config.apply(opts)
    local cfg = config.get()

    if cfg.events.register then
       events.register()
    end

    autosave.enabled = true
    require('autosave.events').fire_hook('on_enable')
end

autosave.enabled = false
return autosave
