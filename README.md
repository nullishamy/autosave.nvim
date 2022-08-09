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
-- filters.opt 
-- filters.not_empty 
-- filters.modifiable 
-- filters.writeable 
-- filters.modified 
-- filters.filetype 
-- filters.custom 
-- Each filter has luadoc to describe its functionality and usage.
require('autosave').setup({
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
        filters.writeable,
        filters.not_empty,
        filters.modified,
    },
    hooks = {
        on_enable = nil,  -- Called when the plugin is enabled for the first time.
        pre_write = nil,  -- Called before the write sequence begins. (This happens before filter checks)
        post_write = nil, -- Called after the write sequence. (This happens after the buffer has been saved)
    }
})
```
