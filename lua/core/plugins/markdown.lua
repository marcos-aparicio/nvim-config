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
      document = {
        -- Turn on / off document rendering.
        enabled = true,
        -- Additional modes to render document.
        render_modes = false,
        -- Ability to conceal arbitrary ranges of text based on lua patterns, @see :h lua-patterns.
        -- Relies entirely on user to set patterns that handle their edge cases.
        conceal = {
            -- Matched ranges will be concealed using character level conceal.
            char_patterns = {
                "=%s*date%(.-%) %- date%(%d%d%d%d%-%d%d%-%d%d%)",
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
			vim.keymap.set("n", "<C-r>", "<cmd>AutolistRecalculate<cr>")

      vim.keymap.set("n", "<leader>mo", function()
        local url = vim.fn.expand("<cfile>")
        if url and url:match("^https?://") then
          local open_cmd = vim.g.is_wsl == 1 and { "powershell.exe", "Start-Process" } or { "xdg-open" }
          vim.fn.jobstart(vim.list_extend(open_cmd, { url }), { detach = true })
        else
          vim.notify("No valid URL under cursor", vim.log.levels.WARN)
        end
      end, { buffer = true, desc = "Open markdown link in browser" })

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

      -- these last 2 keymaps are not from me but from linkarzu:
      -- https://github.com/linkarzu/dotfiles-latest/tree/main
      -- checkout his amazing dotfiles!
      vim.keymap.set("n", "<leader>tc", function()
        require("telescope.builtin").grep_string(require("telescope.themes").get_ivy({
          prompt_title = "Completed Tasks",
          -- search = [[- \[x\] `done:]], -- Regex to match the text "`- [x] `done:"
          -- search = "^- \\[x\\] `done:", -- Matches lines starting with "- [x] `done:"
          search = "^\\s*- \\[x\\]", -- also match blank spaces at the beginning
          search_dirs = { vim.fn.getcwd() }, -- Restrict search to the current working directory
          use_regex = true, -- Enable regex for the search term
          initial_mode = "normal", -- Start in normal mode
          layout_config = {
            preview_width = 0.5, -- Adjust preview width
          },
          wrap_results = true,
          additional_args = function()
            return { "--no-ignore" } -- Include files ignored by .gitignore
          end,
        }))
      end, { desc = "[P]Search for completed tasks" })

      vim.keymap.set("n", "<leader>tt", function()
        require("telescope.builtin").grep_string(require("telescope.themes").get_ivy({
          prompt_title = "Incomplete Tasks",
          -- search = "- \\[ \\]", -- Fixed search term for tasks
          -- search = "^- \\[ \\]", -- Ensure "- [ ]" is at the beginning of the line
          search = "^\\s*- \\[ \\]", -- also match blank spaces at the beginning
          search_dirs = { vim.fn.getcwd() }, -- Restrict search to the current working directory
          use_regex = true, -- Enable regex for the search term
          initial_mode = "normal", -- Start in normal mode
          layout_config = {
            preview_width = 0.5, -- Adjust preview width
          },
          additional_args = function()
            return { "--no-ignore" } -- Include files ignored by .gitignore
          end,
        }))
      end, { desc = "[P]Search for incomplete tasks" })


			-- vim.keymap.set("n", "<localleader>d", "<cmd>AutolistToggleCheckbox<cr><CR>")

      -- If an item is moved to that heading, it will be added the `done` label
      vim.keymap.set("n", "<localleader>d", function()
        -- Customizable variables
        -- NOTE: Customize the completion label
        local label_done = "#_done"
        -- NOTE: Customize the timestamp format
        local timestamp = os.date("%y%m%d-%H%M")
        -- local timestamp = os.date("%y%m%d")
        -- NOTE: Customize the heading and its level
        local tasks_heading = "## Completed tasks"
        -- Save the view to preserve folds
        vim.cmd("mkview")
        local api = vim.api
        -- Retrieve buffer & lines
        local buf = api.nvim_get_current_buf()
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local start_line = cursor_pos[1] - 1
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local total_lines = #lines
        -- If cursor is beyond last line, do nothing
        if start_line >= total_lines then
          vim.cmd("loadview")
          return
        end
        ------------------------------------------------------------------------------
        -- (A) Move upwards to find the bullet line (if user is somewhere in the chunk)
        ------------------------------------------------------------------------------
        while start_line > 0 do
          local line_text = lines[start_line + 1]
          -- Stop if we find a blank line or a bullet line
          if line_text == "" or line_text:match("^%s*%-") then
            break
          end
          start_line = start_line - 1
        end
        -- Now we might be on a blank line or a bullet line
        if lines[start_line + 1] == "" and start_line < (total_lines - 1) then
          start_line = start_line + 1
        end
        ------------------------------------------------------------------------------
        -- (B) Validate that it's actually a task bullet, i.e. '- [ ]' or '- [x]'
        ------------------------------------------------------------------------------
        local bullet_line = lines[start_line + 1]
        if not bullet_line:match("^%s*%- %[[x ]%]") then
          -- Not a task bullet => show a message and return
          print("Not a task bullet: no action taken.")
          vim.cmd("loadview")
          return
        end
        ------------------------------------------------------------------------------
        -- 1. Identify the chunk boundaries
        ------------------------------------------------------------------------------
        local chunk_start = start_line
        local chunk_end = start_line
        while chunk_end + 1 < total_lines do
          local next_line = lines[chunk_end + 2]
          if next_line == "" or next_line:match("^%s*%-") then
            break
          end
          chunk_end = chunk_end + 1
        end
        -- Collect the chunk lines
        local chunk = {}
        for i = chunk_start, chunk_end do
          table.insert(chunk, lines[i + 1])
        end
        ------------------------------------------------------------------------------
        -- 2. Check if chunk has [done: ...] or [untoggled], then transform them
        ------------------------------------------------------------------------------
        local has_done_index = nil
        local has_untoggled_index = nil
        for i, line in ipairs(chunk) do
          -- Replace `[done: ...]` -> `` `done: ...` ``
          chunk[i] = line:gsub("%[#_done([^%]]+)%]", "" .. label_done .. " `%1`")
          -- Replace `[untoggled]` -> `` `untoggled` ``
          chunk[i] = chunk[i]:gsub("%[untoggled%]", "`untoggled`")
          if chunk[i]:match("`" .. label_done .. ".-`") then
            has_done_index = i
            break
          end
        end
        if not has_done_index then
          for i, line in ipairs(chunk) do
            if line:match("`untoggled`") then
              has_untoggled_index = i
              break
            end
          end
        end
        ------------------------------------------------------------------------------
        -- 3. Helpers to toggle bullet
        ------------------------------------------------------------------------------
        -- Convert '- [ ]' to '- [x]'
        local function bulletToX(line)
          return line:gsub("^(%s*%- )%[%s*%]", "%1[x]")
        end
        -- Convert '- [x]' to '- [ ]'
        local function bulletToBlank(line)
          return line:gsub("^(%s*%- )%[x%]", "%1[ ]")
        end
        ------------------------------------------------------------------------------
        -- 4. Insert or remove label *after* the bracket
        ------------------------------------------------------------------------------
        local function insertLabelAfterBracket(line, label)
          local prefix = line:match("^(%s*%- %[[x ]%])")
          if not prefix then
            return line
          end
          local rest = line:sub(#prefix + 1)
          return prefix .. " " .. label .. rest
        end
        local function removeLabel(line)
          -- If there's a label (like `` `done: ...` `` or `` `untoggled` ``) right after
          -- '- [x]' or '- [ ]', remove it
          return line:gsub("^(%s*%- %[[x ]%])%s+`.-`", "%1")
        end
        ------------------------------------------------------------------------------
        -- 5. Update the buffer with new chunk lines (in place)
        ------------------------------------------------------------------------------
        local function updateBufferWithChunk(new_chunk)
          for idx = chunk_start, chunk_end do
            lines[idx + 1] = new_chunk[idx - chunk_start + 1]
          end
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        end
        ------------------------------------------------------------------------------
        -- 6. Main toggle logic
        ------------------------------------------------------------------------------
        local complete_format =  label_done .. " `" .. timestamp .. "`"

        if has_done_index then
          chunk[has_done_index] = removeLabel(chunk[has_done_index]):gsub("`" .. label_done .. ".-`", "`untoggled`")
          chunk[1] = bulletToBlank(chunk[1])
          chunk[1] = removeLabel(chunk[1])
          chunk[1] = insertLabelAfterBracket(chunk[1], "`untoggled`")
          updateBufferWithChunk(chunk)
          vim.notify("Untoggled", vim.log.levels.INFO)
        elseif has_untoggled_index then
          chunk[has_untoggled_index] =
            removeLabel(chunk[has_untoggled_index]):gsub("`untoggled`", complete_format)
          chunk[1] = bulletToX(chunk[1])
          chunk[1] = removeLabel(chunk[1])
          chunk[1] = insertLabelAfterBracket(chunk[1], complete_format)
          updateBufferWithChunk(chunk)
          vim.notify("Completed", vim.log.levels.INFO)
        else
          -- Save original window view before modifications
          local win = api.nvim_get_current_win()
          local view = api.nvim_win_call(win, function()
            return vim.fn.winsaveview()
          end)
          chunk[1] = bulletToX(chunk[1])
          chunk[1] = insertLabelAfterBracket(chunk[1], complete_format)
          -- Remove chunk from the original lines
          for i = chunk_end, chunk_start, -1 do
            table.remove(lines, i + 1)
          end
          -- Append chunk under 'tasks_heading'
          local heading_index = nil
          for i, line in ipairs(lines) do
            if line:match("^" .. tasks_heading) then
              heading_index = i
              break
            end
          end
          if heading_index then
            for _, cLine in ipairs(chunk) do
              table.insert(lines, heading_index + 1, cLine)
              heading_index = heading_index + 1
            end
            -- Remove any blank line right after newly inserted chunk
            local after_last_item = heading_index + 1
            if lines[after_last_item] == "" then
              table.remove(lines, after_last_item)
            end
          else
            table.insert(lines, tasks_heading)
            for _, cLine in ipairs(chunk) do
              table.insert(lines, cLine)
            end
            local after_last_item = #lines + 1
            if lines[after_last_item] == "" then
              table.remove(lines, after_last_item)
            end
          end
          -- Update buffer content
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
          vim.notify("Completed", vim.log.levels.INFO)
          -- Restore window view to preserve scroll position
          api.nvim_win_call(win, function()
            vim.fn.winrestview(view)
          end)
        end
        -- Write changes and restore view to preserve folds
        -- "Update" saves only if the buffer has been modified since the last save
        vim.cmd("silent update")
        vim.cmd("loadview")
      end, { desc = "[P]Toggle task and move it to 'done'" })

      -- vim.api.nvim_create_autocmd("FileType", {
      --   pattern = "markdown",
      --   callback = function()
      --     vim.opt.conceallevel = 2
      --   end,
      -- })
		end,
	},
}
