<p align="center">
  <h1 align="center">autosave.nvim</h1>
</p>

A simple autosave plugin for neovim that aims to improve on existing solutions by being more stable, less bug prone
and more customisable.

This project uses semantic versioning, with a promise for backwards compatiblity, so you never experience unexpected changes.

## Dependencies
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)

## Installation

Install with your preferred package manager
<details>
	<summary><a href="https://github.com/wbthomason/packer.nvim">packer.nvim</a></summary>

```lua
use({
  "nullishamy/autosave.nvim",
})
```

</details>

<details>
	<summary><a href="https://github.com/junegunn/vim-plug">vim-plug</a></summary>

```vim
Plug 'nullishamy/autosave.nvim'
```

</details>

## Configuration
This plugin has the usual setup method. Below are the defaults:
```lua
local filters = require('autosave.filters')
-- Available filters:
-- filters.git_repo
-- filters.invert
-- filters.opt 
-- filters.not_empty 
-- filters.modifiable 
-- filters.writeable 
-- filters.modified 
-- filters.filetype 
-- filters.custom 
-- Each filter has luadoc to describe its functionality and usage.
require('autosave').setup({
    plugin = {
        force = false, -- Whether to forcefully write or not (:w!)
    },
    events = {
        register = true, -- Should autosave register its autocommands
        triggers = { -- The autocommands to register, if enabled
            'InsertLeave', 'TextChanged'
        }
    },
    debounce = {
        enabled = true, -- Should debouncing be enabled
        delay = 250 -- If enabled, only save the file at most every `delay` ms
    },
    filters = { -- The filters to apply, see above for all options.
        -- These filters are required for basic operation as they prevent
        -- errors related to to buffer state.
        filters.writeable,
        filters.not_empty,
        filters.modified,
    },
    hooks = {
        on_enable = nil,   -- Called when the plugin is enabled for the first time.
        pre_filter = nil,  -- Called before the write sequence begins. (This happens before filter checks)
        pre_write = nil,   -- Called before the buffer is written (This happens after all checks pass)
        post_write = nil,  -- Called after the write sequence. (This happens after the buffer has been saved)
    }
})
```
 
 ## Format on save

 When using an on-save format solution with this plugin, special care needs to be taken to avoid errors or strange behaviour.

 It is advised to put the formatting logic in the `pre_write` hook.

 ```lua
require('autosave').setup({
    hooks = {
        pre_write = function()
            vim.cmd [[ Neoformat ]]
        end
    }
})
 ```
  
## Actions

This plugin exposes a Lua API for performing various actions.
All actions require the plugin to have been setup with the `setup()` method, detailed above, to work properly.

```lua
local actions = require('autosave.actions')

actions.buf_enable()     -- Enable the plugin for the current buffer.
actions.buf_disable()    -- Disable the plugin for the current buffer.
actions.buf_toggle()     -- Toggle the plugin on or off for the current buffer.

actions.global_enable()  -- Enable the plugin globally.
actions.global_disable() -- Disable the plugin globally.
actions.global_toggle()  -- Toggle the plugin on or off globally.

actions.save()           -- Run the save sequence.
actions.show_status()    -- Display the status of the plugin.
```

## Ex-commands

Each of the above actions has a corresponding ex-command, listed below.

:ASGlobalEnable   -- Enable the plugin globally.
:ASGlobalDisable  -- Disable the plugin globally.
:ASGlobalToggle   -- Toggle the plugin on or off globally.

:ASEnable         -- Enable the plugin for the current buffer.           
:ASDisable        -- Disable the plugin for the current buffer.
:ASToggle         -- Toggle the plugin on or off for the current buffer.

:ASStatus         -- Display the status of the plugin.
