# telescope-buffer-lines.nvim

Find lines from across all open buffers and insert selected into current buffer.

## Requirements

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) (required)

## Setup

You can setup the extension by doing

```lua
require('telescope').load_extension('buffer_lines')
```

somewhere after your `require('telescope').setup()` call.

## Available functions

```lua
require'telescope'.extensions.buffer_lines.buffer_lines{}
```

or

```vim
:Telescope buffer_lines
```

