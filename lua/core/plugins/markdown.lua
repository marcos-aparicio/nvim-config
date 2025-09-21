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
			heading = {
				sign = true,
				-- position = 'inline',
				-- width = 'block',
				icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
				custom = {
					todo_pattern = {
						pattern = "^## To Do$",
						icon = "󰲣    ",
					},
					notes_pattern = {
						pattern = "^## Notes$",
						icon = "󰲣  📝 ",
					},
				},
			},
      checkbox={
        custom = {
            todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodoCurrent', scope_highlight = nil },
        },
      }
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function()
          local function filter_non_task_tags(tag)
            return not vim.startswith(tag, "_")
          end


					local function pick_tag_and_search(tag_filter_fn, picker_title)
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
                  if not symbol.name then
                    goto continue
                  end
                  local tag = symbol.name:match("Tag:%s*(.+)")
                  if not tag or (tag_filter_fn and not tag_filter_fn(tag)) then
                    goto continue
                  end
                  tags[tag] = true
                  ::continue::
                end

								local tag_list = vim.tbl_keys(tags)
								if #tag_list == 0 then
									print("No tags found")
									return
								end

								pickers
									.new({}, {
										prompt_title = picker_title and picker_title or "Select Tag",
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
            function()
              pick_tag_and_search(filter_non_task_tags)
            end,
						{ buffer = true, desc = "Pick tag and search" }
					)

					vim.keymap.set(
						"n",
						"<leader>ka",
            function()
              pick_tag_and_search(function (tag)
                return vim.startswith(tag, "_")
              end, "Select Task Tag:")
            end,
						{ buffer = true, desc = "Pick tag and search" }
					)


					local function jump_to_header(header_text, keymap, desc)
						vim.keymap.set("n", keymap, function()
							local current_pos = vim.fn.getpos(".")
							vim.cmd("normal! gg") -- Go to top
							local found = vim.fn.search("^## " .. header_text, "W")
							if found > 0 then
								vim.cmd("normal! j") -- Move one line down
							else
								vim.fn.setpos(".", current_pos) -- Return to original position
								vim.notify('Header "## ' .. header_text .. '" not found', vim.log.levels.WARN)
							end
						end, { desc = desc })
					end

          -- all credit to linkarzu's dotfiles! thsi section is definitely not ma code
          -- https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/config/keymaps.lua
          vim.keymap.set("n", "<leader>md", function()
            -- Get the current cursor position
            local cursor_pos = vim.api.nvim_win_get_cursor(0)
            local current_buffer = vim.api.nvim_get_current_buf()
            local start_row = cursor_pos[1] - 1
            local col = cursor_pos[2]
            -- Get the current line
            local line = vim.api.nvim_buf_get_lines(current_buffer, start_row, start_row + 1, false)[1]
            -- Check if the line already starts with a bullet point
            if line:match("^%s*%-") then
              -- Remove the bullet point from the start of the line
              line = vim.trim(line:gsub("^%s*%-", ""))
              vim.api.nvim_buf_set_lines(current_buffer, start_row, start_row + 1, false, { line })
              return
            end
            -- Search for newline to the left of the cursor position
            local left_text = line:sub(1, col)
            local bullet_start = left_text:reverse():find("\n")
            if bullet_start then
              bullet_start = col - bullet_start
            end
            -- Search for newline to the right of the cursor position and in following lines
            local right_text = line:sub(col + 1)
            local bullet_end = right_text:find("\n")
            local end_row = start_row
            while not bullet_end and end_row < vim.api.nvim_buf_line_count(current_buffer) - 1 do
              end_row = end_row + 1
              local next_line = vim.api.nvim_buf_get_lines(current_buffer, end_row, end_row + 1, false)[1]
              if next_line == "" then
                break
              end
              right_text = right_text .. "\n" .. next_line
              bullet_end = right_text:find("\n")
            end
            if bullet_end then
              bullet_end = col + bullet_end
            end
            -- Extract lines
            local text_lines = vim.api.nvim_buf_get_lines(current_buffer, start_row, end_row + 1, false)
            local text = table.concat(text_lines, "\n")
            -- Add bullet point at the start of the text
            local new_text = "- " .. text
            local new_lines = vim.split(new_text, "\n")
            -- Set new lines in buffer
            vim.api.nvim_buf_set_lines(current_buffer, start_row, end_row + 1, false, new_lines)
          end, { desc = "[P]Toggle bullet point (dash)" })


          vim.keymap.set("n", "<leader>ml", function()
            -- Get the current cursor position
            local cursor_pos = vim.api.nvim_win_get_cursor(0)
            local current_buffer = vim.api.nvim_get_current_buf()
            local start_row = cursor_pos[1] - 1
            local col = cursor_pos[2]
            -- Get the current line
            local line = vim.api.nvim_buf_get_lines(current_buffer, start_row, start_row + 1, false)[1]
            -- Check if the line already starts with a todo point
            if line:match("^%s*%- %s[.]") then
              -- Remove the bullet point from the start of the line
              line = vim.trim(line:gsub("^%s*%-%s[.]", ""))
              vim.api.nvim_buf_set_lines(current_buffer, start_row, start_row + 1, false, { line })
              return
            end
            -- Search for newline to the left of the cursor position
            local left_text = line:sub(1, col)
            local bullet_start = left_text:reverse():find("\n")
            if bullet_start then
              bullet_start = col - bullet_start
            end
            -- Search for newline to the right of the cursor position and in following lines
            local right_text = line:sub(col + 1)
            local bullet_end = right_text:find("\n")
            local end_row = start_row
            while not bullet_end and end_row < vim.api.nvim_buf_line_count(current_buffer) - 1 do
              end_row = end_row + 1
              local next_line = vim.api.nvim_buf_get_lines(current_buffer, end_row, end_row + 1, false)[1]
              if next_line == "" then
                break
              end
              right_text = right_text .. "\n" .. next_line
              bullet_end = right_text:find("\n")
            end
            if bullet_end then
              bullet_end = col + bullet_end
            end
            -- Extract lines
            local text_lines = vim.api.nvim_buf_get_lines(current_buffer, start_row, end_row + 1, false)
            local text = table.concat(text_lines, "\n")
            -- Add bullet point at the start of the text
            local new_text = "- [ ] " .. text
            local new_lines = vim.split(new_text, "\n")
            -- Set new lines in buffer
            vim.api.nvim_buf_set_lines(current_buffer, start_row, end_row + 1, false, new_lines)
          end, { desc = "[P]Toggle todo(dash)" })


					jump_to_header("To Do", "<leader>mt", "Jump to To Do section")
					jump_to_header("Notes", "<leader>mn", "Jump to Notes section")
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
