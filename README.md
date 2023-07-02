# My Nvim Config

repo to show my nvim plugins, remappings and all that stuff. Hopefully this repo will be merge to a dotfiles repo at some point.

> :warning: **This config allows a basic version of bootstraping.** However, the first time you run this, only some configurations will load since all plugins are being download. When opening neovim again, everything should work fine ( nvim-treesitter configs might take a while to load the second time you open neovim with this config but after that it works fine )

> :warning: **be sure to install the needed formatters(stylua)**
> `mappings.lua` will have mappings not dependant on any extensions and will export functions for better mapping creation(those functions will be used to add mappings that depend on extensions based on that extensions config file) depending on if that extension is a neovim or vim one
