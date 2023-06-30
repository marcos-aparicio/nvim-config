-- this file also includes all treesitter extensions
local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end
local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")

telescope.setup({
	defaults = {
		path_display = { "shorten" },
		mappings = {
			i = {
				["<C-c>"] = actions.close,
				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-p>"] = action_layout.toggle_preview,
			},
			n = {
				["q"] = actions.close,
				["p"] = action_layout.toggle_preview,
			},
		},
	},
	pickers = {
		marks = {
			layout_strategy = "horizontal",
			layout_config = {
				width = 0.9,
				preview_width = 0.3,
			},
		},
	},
})

telescope.load_extension("fzf")
telescope.load_extension("project")
telescope.load_extension("repo")
telescope.load_extension("workspaces")
telescope.load_extension("vimwiki")
telescope.load_extension("vim_bookmarks")
