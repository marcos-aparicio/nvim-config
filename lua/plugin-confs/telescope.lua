-- this file also includes all treesitter extensions
local M = require("mappings")
local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end
local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")
local action_state = require("telescope.actions.state")

telescope.load_extension("workspaces")
telescope.load_extension("vimwiki")
telescope.load_extension("vim_bookmarks")

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
		find_files = {
			file_ignore_patterns = { "node_modules" },
		},
		git_branches = {
			mappings = {
				n = {
					yy = function()
						local entry = action_state.get_selected_entry()
						vim.fn.setreg("+", entry.value)
						print(entry.value .. " was copied to the clipboard")
					end,
				},
			},
		},
	},
})

M.nmap("<leader>f", ":Telescope find_files<CR>")
M.nmap("<leader>tt", ":Telescope live_grep<CR>")
M.nmap("<leader>p", ":Telescope workspaces<CR>")

M.nmap(
	"<leader>rf",
	[[:lua require('telescope.builtin').find_files({no_ignore=true,find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" }})<CR>]]
)

M.nmap("ma", ":Telescope vim_bookmarks current_file<CR>")
-- I think these are dependant in vim fugitive
M.nmap("<leader>gs", ":Telescope git_status<CR>")
M.nmap("<leader>gb", ":Telescope git_branches<CR>")
M.nmap("<leader>/", ":Telescope current_buffer_fuzzy_find<CR>")
