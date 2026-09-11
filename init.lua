-- Byte-compiled Lua module cache. Must run before the first require so that
-- everything below (and every plugin) is served from the cache.
vim.loader.enable()

require("settings")
require("autocmds")
require("commands")
require("datediff")
require("lazy-nvim")
require("mappings")
