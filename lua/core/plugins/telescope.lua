local M = require("mappings")
return {
	"nvim-telescope/telescope-live-grep-args.nvim",
	"nooproblem/git-worktree.nvim",
	{
		"nvim-telescope/telescope.nvim",
		branch = "master",
		-- tag = "0.1.6",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local action_layout = require("telescope.actions.layout")
			local action_state = require("telescope.actions.state")

			telescope.load_extension("live_grep_args")
			telescope.load_extension("workspaces")
			telescope.load_extension("bookmarks")
			telescope.load_extension("git_worktree")

			-- other_opts = {
			-- 	dynamic_preview_title = true,
			-- 	layout_strategy = "vertical",
			-- 	layout_config = { vertical = { width = 0.9, height = 0.9, preview_height = 0.6, preview_cutoff = 0 } },
			-- 	path_display = { "smart", shorten = { len = 3 } },
			-- 	wrap_results = true,
			-- }

			telescope.setup({
				defaults = {
					theme = "ivy",
					layout_config = {
						width = 0.9,
						preview_width = 0.6,
						height = 0.9,
						prompt_position = "top",
					},

					wrap_results = true,
					-- layout_strategy = "vertical",
					-- layout_config = {
					-- 	vertical = { width = 0.9, height = 0.9, preview_height = 0.6, preview_cutoff = 0 },
					-- },
					-- path_display = { "truncate" },
					mappings = {
						i = {
							["<C-c>"] = actions.close,
							["<C-x>"] = actions.select_horizontal,
							["<C-v>"] = actions.select_vertical,
							["<C-p>"] = action_layout.toggle_preview,
						},
						n = {
							["q"] = actions.close,
							["<C-p>"] = action_layout.toggle_preview,
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
								ff = function(prompt_bufnr)
									local entry = action_state.get_selected_entry()
									local selected_branch = entry.value
									local remote_repos = vim.fn.systemlist("git remote show")
									local processed_branch = selected_branch
									for _, remote_repo in pairs(remote_repos) do
										if string.find(selected_branch, "^" .. remote_repo .. "/") then
											processed_branch =
												string.gsub(selected_branch, "^" .. remote_repo .. "/", "")
											break
										end
									end

									if processed_branch == selected_branch then
										print("This branch is not remote!")
										return
									end

									actions.close(prompt_bufnr)
									vim.fn.system("git checkout " .. processed_branch)
									print("git checkout to " .. processed_branch)
								end,
								rr = function(prompt_bufnr)
									local entry = action_state.get_selected_entry()
									local selected_branch = entry.value
									-- checkout out to a random branch
									actions.close(prompt_bufnr)
									vim.fn.system("git checkout $(git branch -- list | shuf -n 1 | sed '/^\\* //')")
									vim.api.nvim_feedkeys(":G branch -m " .. selected_branch .. " ", "n", true)
									print("Branch: " .. selected_branch .. " was renamed")
								end,
							},
						},
					},
				},
				extensions = {
					bookmarks = {
						list = {
							theme = "ivy",
							layout_config = {
								width = 0.8,
							},
						},
					},
				},
			})

			M.nmap("<leader>f", ":Telescope find_files<CR>")
			M.nmap("<leader>ll", ':lua require("telescope").extensions.live_grep_args.live_grep_args()<CR>')
			M.nmap("<leader>p", ":Telescope workspaces<CR>")

			M.nmap(
				"<leader>rf",
				[[:lua require('telescope.builtin').find_files({no_ignore=true,find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" }})<CR>]]
			)

			-- I think these are dependant in vim fugitive
			M.nmap("<leader>gs", ":Telescope git_status<CR>")
			M.nmap("<leader>gb", ":Telescope git_branches<CR>")
			M.nmap("<leader>/", ":Telescope current_buffer_fuzzy_find<CR>")
			M.nmap("<leader>gt", ":lua require('telescope').extensions.git_worktree.git_worktrees()<CR>")
			M.nmap("<leader>gnt", ":lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>")
		end,
	},
}
