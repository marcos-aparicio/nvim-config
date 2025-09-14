local list_patterns = {
	unordered = "[-+*]", -- - + *
	digit = "%d+[.)]", -- 1. 2. 3.
	ascii = "%a[.)]", -- a) b) c)
	roman = "%u*[.)]", -- I. II. III.
	latex_item = "\\item",
}

return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' }, -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			-- Customize bullet icons
			bullet = {
				icons = { "• ", "‣ ", "∙ ", "◦ " }, -- Small and clean bullet icons
			},
		},
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function()
					local function pick_tag_and_search()
						local telescope = require("telescope.builtin")
						local pickers = require("telescope.pickers")
						local finders = require("telescope.finders")
						local conf = require("telescope.config").values
						local actions = require("telescope.actions")
						local action_state = require("telescope.actions.state")

						vim.lsp.buf_request(
							0,
							"workspace/symbol",
							{ query = "Tag:" },
							function(err, result, ctx, config)
								if err or not result then
									print("No tags found")
									return
								end

								local tags = {}
								for _, symbol in ipairs(result) do
									if symbol.name then
										local tag = symbol.name:match("Tag:%s*(.+)")
										if tag then
											tags[tag] = true
										end
									end
								end

								local tag_list = vim.tbl_keys(tags)
								if #tag_list == 0 then
									print("No tags found")
									return
								end

								pickers
									.new({}, {
										prompt_title = "Select Tag",
										finder = finders.new_table({
											results = tag_list,
										}),
										sorter = conf.generic_sorter({}),
										attach_mappings = function(prompt_bufnr, map)
											actions.select_default:replace(function()
												actions.close(prompt_bufnr)
												local selection = action_state.get_selected_entry()
												if selection then
													telescope.lsp_workspace_symbols({ query = "Tag: " .. selection[1] })
												end
											end)
											return true
										end,
									})
									:find()
							end
						)
					end

					vim.keymap.set(
						"n",
						"<leader>kt",
						pick_tag_and_search,
						{ buffer = true, desc = "Pick tag and search" }
					)
				end,
			})
		end,
	},
	{
		"gaoDean/autolist.nvim",
		ft = {
			"markdown",
			"text",
			"tex",
			"plaintex",
			"norg",
		},
		config = function()
			require("autolist").setup({
				lists = {
					markdown = {
						list_patterns.unordered,
						list_patterns.digit,
						list_patterns.ascii, -- for example this specifies activate the ascii list
						list_patterns.roman, -- type for markdown files.
						"[>*]",
					},
				},
			})

			vim.keymap.set("i", "<tab>", "<cmd>AutolistTab<cr>")
			vim.keymap.set("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>")
			-- vim.keymap.set("i", "<c-t>", "<c-t><cmd>AutolistRecalculate<cr>") -- an example of using <c-t> to indent
			vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")
			vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr>")
			vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr>")
			vim.keymap.set("n", "<localleader>d", "<cmd>AutolistToggleCheckbox<cr><CR>")
			vim.keymap.set("n", "<C-r>", "<cmd>AutolistRecalculate<cr>")

			-- cycle list types with dot-repeat
			vim.keymap.set("n", "<leader>cn", require("autolist").cycle_next_dr, { expr = true })
			-- vim.keymap.set("n", "<leader>cp", require("autolist").cycle_prev_dr, { expr = true })

			-- if you don't want dot-repeat
			-- vim.keymap.set("n", "<leader>cn", "<cmd>AutolistCycleNext<cr>")
			-- vim.keymap.set("n", "<leader>cp", "<cmd>AutolistCycleNext<cr>")

			-- functions to recalculate list on edit
			vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>")
			vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>")
			vim.keymap.set("n", "dd", "dd<cmd>AutolistRecalculate<cr>")
			vim.keymap.set("v", "d", "d<cmd>AutolistRecalculate<cr>")
		end,
	},
}
