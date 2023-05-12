-- this file also includes all treesitter extensions
local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end
local actions = require("telescope.actions")

telescope.setup({
  defaults = { path_display = { "shorten" } },
  mappings = {
    i = {
      ["<C-c>"] = actions.close,
      ["<C-x>"] = actions.select_horizontal,
      ["<C-v>"] = actions.select_vertical,
    },
    n = {
      ["q"] = actions.close,
    },
  },
})
