local actions = require("telescope.actions")
local function setup() end
require("telescope").setup({
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
return setup
