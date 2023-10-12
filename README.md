# Neovim UI selector by FZF

This plugin, once installed, replaces `vim.ui.select` function and provides
a floating window popup with fuzzy searching or selection by numbers.

Built with
[luasnip-antora-locator](https://github.com/cpkio/luasnip-antora-locator) in
mind.

## Requirements

* `fzf` in path
* [nvim-fzf](https://github.com/vijaymarupudi/nvim-fzf)
* [nvim-fzf-commands-windows](https://github.com/cpkio/nvim-fzf-commands-win)
  only to set my `fzf` fields separator and use some terminal utilities

## Features

* Opens at cursor a floating window with height enough to fit all the selection items
* Floating window opens on top of current line if cursor is currently in lower
  half of the screen, or below otherwise

## Usage (in `luasnip`)

Set up a map to open `vim.ui.select` window:

```lua
vim.api.nvim_set_keymap('i', '<M-o>', '', {
  desc = "",
  noremap = true, silent = true,
  callback = function()
    require("luasnip.extras.select_choice")()
  end
})
```
