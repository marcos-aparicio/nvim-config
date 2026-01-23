local M = {}

local bookmarks_repo = os.getenv("HOME") .. "/Documents/Areas/Obsidian/bookmarks"

-- Helper to find project root by locating .obsidian directory
local function find_obsidian_root(start_path)
  local Path = require("plenary.path")
  local buf_path = vim.fn.expand("%:p")
  local path = Path:new(start_path or (buf_path ~= "" and buf_path or vim.fn.getcwd()))
  while tostring(path) ~= tostring(path:parent()) do
    if Path:new(path, ".obsidian"):is_dir() then
      return tostring(path)
    end
    path = path:parent()
  end
  return nil
end

local function open_diary_note_for_date(date_str)
  local plenary_ok, _ = pcall(require, "plenary.path")
  if not plenary_ok then
    vim.notify("plenary.nvim is required for diary keymap", vim.log.levels.ERROR)
    return
  end
  local root = find_obsidian_root()
  if not root then
    vim.notify("Could not find .obsidian directory in parent folders", vim.log.levels.ERROR)
    return
  end

  if root == bookmarks_repo then
    vim.notify("You are in bookmarks repo!", vim.log.levels.ERROR)
    return
  end

  local templates_path = root .. "/templates"
  local diary_template = templates_path .. "/diary.md"
  local diary_dir = root .. "/diary"

  if vim.fn.isdirectory(diary_dir) == 0 then
    vim.fn.mkdir(diary_dir, "p")
  end

  local diary_file = diary_dir .. "/" .. date_str .. ".md"
  if vim.fn.filereadable(diary_file) == 0 then
    local diary_content
    if vim.fn.filereadable(diary_template) == 1 then
      -- Read template and replace placeholders
      diary_content = vim.fn.readfile(diary_template)
      for i, line in ipairs(diary_content) do
        diary_content[i] = line:gsub("{{date:YYYY%-MM%-DD}}", date_str)
      end
    else
      -- Fallback to hardcoded content
      diary_content = {
        "# " .. date_str .. " Diary",
        "",
        "## Notes",
        "",
        ".",
        "",
        "## Todo",
        "",
        ".",
      }
    end
    vim.fn.writefile(diary_content, diary_file)
  end
  vim.cmd("edit " .. diary_file)
end

local function open_weekly_note_for_date(date_str)
  local plenary_ok, _ = pcall(require, "plenary.path")
  if not plenary_ok then
    vim.notify("plenary.nvim is required for weekly note keymap", vim.log.levels.ERROR)
    return
  end
  local root = find_obsidian_root()
  if not root then
    vim.notify("Could not find .obsidian directory in parent folders", vim.log.levels.ERROR)
    return
  end

  if root == bookmarks_repo then
    vim.notify("You are in bookmarks repo!", vim.log.levels.ERROR)
    return
  end

  local function iso_week(date)
    local year_str, month_str, day_str = date:match("(%d+)%-(%d+)%-(%d+)")
    if not year_str or not month_str or not day_str then
      return nil
    end
    local year, month, day = tonumber(year_str), tonumber(month_str), tonumber(day_str)
    if not year or not month or not day then
      return nil
    end
    local t = os.time({ year = year, month = month, day = day })
    local dow = tonumber(os.date("%u", t))
    local thursday = t + (4 - dow) * 24 * 60 * 60
    local week = tonumber(os.date("%V", thursday))
    local week_year = tonumber(os.date("%G", thursday))
    return string.format("%d-W%02d", week_year, week)
  end

  local week_str = iso_week(date_str)
  if not week_str then
    vim.notify("Invalid date format", vim.log.levels.ERROR)
    return
  end

  local templates_path = root .. "/templates"
  local weekly_template = templates_path .. "/weekly.md"
  local diary_dir = root .. "/diary"

  if vim.fn.isdirectory(diary_dir) == 0 then
    vim.fn.mkdir(diary_dir, "p")
  end

  local weekly_file = diary_dir .. "/" .. week_str .. ".md"
  if vim.fn.filereadable(weekly_file) == 0 then
    local weekly_content
    if vim.fn.filereadable(weekly_template) == 1 then
      -- Read template and replace placeholders
      weekly_content = vim.fn.readfile(weekly_template)
      for i, line in ipairs(weekly_content) do
        weekly_content[i] = line:gsub("{{date:YYYY%-%[W%]WW}}", week_str)
      end
    else
      -- Fallback to hardcoded content
      weekly_content = {
        "# " .. week_str .. " Weekly",
        "",
        "## Goals",
        "",
        ".",
        "",
        "## Review",
        "",
        ".",
      }
    end
    vim.fn.writefile(weekly_content, weekly_file)
  end
  vim.cmd("edit " .. weekly_file)
end

local function create_task_with_tags()
  local telescope = require("core.plugins.markdown.telescope")
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  -- Get all task tags
  local task_tags = telescope.get_all_task_tags()

  if not task_tags or #task_tags == 0 then
    vim.notify("No task tags found", vim.log.levels.WARN)
    return
  end

  pickers
    .new({}, {
      prompt_title = "Select Task Tags (Tab/C-x to select, Enter to confirm)",
      finder = finders.new_table({
        results = task_tags,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry,
            ordinal = entry,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        -- Multi-select mappings for both insert and normal mode
        map("i", "<Tab>", actions.toggle_selection)
        map("n", "<Tab>", actions.toggle_selection)
        map("i", "<C-x>", actions.toggle_selection)
        map("n", "<C-x>", actions.toggle_selection)

        -- Confirm selection for both insert and normal mode
        actions.select_default:replace(function()
          local picker = action_state.get_current_picker(prompt_bufnr)
          local multi = picker:get_multi_selection()
          local tags = {}

          if #multi == 0 then
            local selection = action_state.get_selected_entry()
            if selection then
              table.insert(tags, "#" .. selection.value)
            end
          else
            for _, entry in ipairs(multi) do
              table.insert(tags, "#" .. entry.value)
            end
          end

          actions.close(prompt_bufnr)

          local tag_string = ""
          if #tags > 0 then
            tag_string = " " .. table.concat(tags, " ")
          end

          local task_line = "- [ ]" .. tag_string .. "  "
          local row, col = unpack(vim.api.nvim_win_get_cursor(0))
          local current_line = vim.api.nvim_get_current_line()
          local new_line = current_line:sub(1, col) .. task_line .. current_line:sub(col + 1)
          vim.api.nvim_set_current_line(new_line)
          vim.api.nvim_win_set_cursor(0, { row, col + #task_line + 1 })
          vim.schedule(function()
            vim.cmd("startinsert")
          end)
        end)
        return true
      end,
    })
    :find()
end

local function modify_task_tags()
  local telescope = require("core.plugins.markdown.telescope")
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  -- Get current line and check if it's a task
  local current_line = vim.api.nvim_get_current_line()
  local task_pattern = "^%s*%- %[[ x%-]%]"

  if not current_line:match(task_pattern) then
    vim.notify("Cursor is not on a task line", vim.log.levels.WARN)
    return
  end

  -- Extract existing tags from the current line
  local existing_tags = {}
  for tag in current_line:gmatch("#([%w%-_/]+)") do
    if vim.startswith(tag, "_") then
      existing_tags[tag] = true
    end
  end

  -- Get all available task tags
  local task_tags = telescope.get_all_task_tags()

  if not task_tags or #task_tags == 0 then
    vim.notify("No task tags found", vim.log.levels.WARN)
    return
  end

  -- Remove the leading underscore for display
  local display_tags = {}
  for _, tag in ipairs(task_tags) do
    table.insert(display_tags, tag:sub(2)) -- Remove the leading "_"
  end

  pickers
    .new({}, {
      prompt_title = "Modify Task Tags (Tab/C-x to toggle, Enter to confirm)",
      finder = finders.new_table({
        results = display_tags,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry,
            ordinal = entry,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        local MultiSelect = require("telescope.pickers.multi")
        local picker = action_state.get_current_picker(prompt_bufnr)
        local multi = MultiSelect:new()
        for i = 1, #picker.finder.results do
          local entry = picker.finder.results[i].value
          if existing_tags["_" .. entry] then
            multi:add(picker.finder.results[i])
          end
        end
        picker:refresh(picker.finder, { multi = multi })

        -- Multi-select mappings for both insert and normal mode
        map("i", "<Tab>", actions.toggle_selection)
        map("n", "<Tab>", actions.toggle_selection)
        map("i", "<C-x>", actions.toggle_selection)
        map("n", "<C-x>", actions.toggle_selection)

        -- Confirm selection for both insert and normal mode
        actions.select_default:replace(function()
          local picker = action_state.get_current_picker(prompt_bufnr)
          local multi = picker:get_multi_selection()
          local selected_tags = {}

          -- Add all toggled tags
          for _, entry in ipairs(multi) do
            selected_tags["_" .. entry.value] = true
          end

          -- Always add the currently highlighted tag
          local selection = action_state.get_selected_entry()
          if selection then
            selected_tags["_" .. selection.value] = true
          end

          actions.close(prompt_bufnr)

          -- Parse the current line to separate task part from tags
          local task_part = current_line:gsub("%s*#[%w%-_]*", "")
          task_part = vim.trim(task_part)

          -- Build new tag string
          local new_tags = {}
          for tag in pairs(selected_tags) do
            table.insert(new_tags, "#" .. tag)
          end

          -- Construct the new line
          local new_line = task_part
          if #new_tags > 0 then
            new_line = new_line .. " " .. table.concat(new_tags, " ")
          end

          -- Replace the current line
          vim.api.nvim_set_current_line(new_line)
        end)
        return true
      end,
    })
    :find()
end

local function open_bookmark_url()
  local buf_path = vim.api.nvim_buf_get_name(0)
  if not buf_path:find(bookmarks_repo, 1, true) then
    vim.notify("Not in bookmarks repo", vim.log.levels.WARN)
    return
  end
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for i, line in ipairs(lines) do
    if line:match("^#### URL") and lines[i + 1] then
      local url = vim.trim(lines[i + 1])
      if url ~= "" and url ~= "." and url:match("^https?://") then
        local open_cmd = vim.g.is_wsl == 1 and { "powershell.exe", "Start-Process" }
          or { "xdg-open" }
        vim.fn.jobstart(vim.list_extend(open_cmd, { url }), { detach = true })
        return
      end
    end
  end
  vim.notify("No valid URL found in bookmark", vim.log.levels.WARN)
end

local function open_random_bookmark_note()
  local plenary_ok, Path = pcall(require, "plenary.path")
  if not plenary_ok then
    vim.notify("plenary.nvim is required for bookmark keymap", vim.log.levels.ERROR)
    return
  end
  local root = find_obsidian_root()
  if not root then
    vim.notify("Could not find .obsidian directory in parent folders", vim.log.levels.ERROR)
    return
  end

  if root ~= bookmarks_repo then
    vim.notify("This is not the bookmars repo!", vim.log.levels.ERROR)
    return
  end

  local function random_string(len)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local s = ""
    for i = 1, len do
      local idx = math.random(1, #chars)
      s = s .. chars:sub(idx, idx)
    end
    return s
  end
  math.randomseed(os.time())
  local filename
  repeat
    filename = random_string(10) .. ".md"
  until vim.fn.filereadable(root .. "/" .. filename) == 0
  local bookmark_file = root .. "/" .. filename
  local template = {
    "# Title: ",
    "",
    "#### URL",
    ".",
    "",
    "#### Description",
    ".",
    "",
    "#### Tags",
    ".",
  }
  vim.fn.writefile(template, bookmark_file)
  vim.cmd("edit " .. bookmark_file)
  vim.api.nvim_win_set_cursor(0, { 1, 10 }) -- set the cursor after Title:
  vim.cmd("startinsert")
end

-- Credit to linkarzu's dotfiles for bullet point functions
local function toggle_bullet_point()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_buffer = vim.api.nvim_get_current_buf()
  local start_row = cursor_pos[1] - 1
  local col = cursor_pos[2]
  local line = vim.api.nvim_buf_get_lines(current_buffer, start_row, start_row + 1, false)[1]

  if line:match("^%s*%-") then
    line = vim.trim(line:gsub("^%s*%-", ""))
    vim.api.nvim_buf_set_lines(current_buffer, start_row, start_row + 1, false, { line })
    return
  end

  local left_text = line:sub(1, col)
  local bullet_start = left_text:reverse():find("\n")
  if bullet_start then
    bullet_start = col - bullet_start
  end

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

  local text_lines = vim.api.nvim_buf_get_lines(current_buffer, start_row, end_row + 1, false)
  local text = table.concat(text_lines, "\n")
  local new_text = "- " .. text
  local new_lines = vim.split(new_text, "\n")
  vim.api.nvim_buf_set_lines(current_buffer, start_row, end_row + 1, false, new_lines)
end

local function toggle_todo_checkbox()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_buffer = vim.api.nvim_get_current_buf()
  local start_row = cursor_pos[1] - 1
  local col = cursor_pos[2]
  local line = vim.api.nvim_buf_get_lines(current_buffer, start_row, start_row + 1, false)[1]

  if line:match("^%s*%- %s[.]") then
    line = vim.trim(line:gsub("^%s*%-%s[.]", ""))
    vim.api.nvim_buf_set_lines(current_buffer, start_row, start_row + 1, false, { line })
    return
  end

  -- Similar logic as toggle_bullet_point but for todo items
  local text_lines = vim.api.nvim_buf_get_lines(current_buffer, start_row, start_row + 1, false)
  local text = table.concat(text_lines, "\n")
  local new_text = "- [ ] " .. text
  local new_lines = vim.split(new_text, "\n")
  vim.api.nvim_buf_set_lines(current_buffer, start_row, start_row + 1, false, new_lines)
end

local function jump_to_header(header_text, keymap, desc)
  vim.keymap.set("n", keymap, function()
    local current_pos = vim.fn.getpos(".")
    vim.cmd("normal! gg")
    local found = vim.fn.search("^## " .. header_text, "W")
    if found > 0 then
      vim.cmd("normal! j")
    else
      vim.fn.setpos(".", current_pos)
      vim.notify('Header "## ' .. header_text .. '" not found', vim.log.levels.WARN)
    end
  end, { desc = desc })
end

local function open_markdown_link()
  local url = vim.fn.expand("<cfile>")
  if url and url:match("^https?://") then
    local open_cmd = vim.g.is_wsl == 1 and { "powershell.exe", "Start-Process" } or { "xdg-open" }
    vim.fn.jobstart(vim.list_extend(open_cmd, { url }), { detach = true })
  else
    vim.notify("No valid URL under cursor", vim.log.levels.WARN)
  end
end

local function open_selected_markdown_link()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
  local text = table.concat(lines, "\n")
  text = vim.trim(text)
  if text and text:match("^https?://") then
    local open_cmd = vim.g.is_wsl == 1 and { "powershell.exe", "Start-Process" } or { "xdg-open" }
    vim.fn.jobstart(vim.list_extend(open_cmd, { text }), { detach = true })
  else
    vim.notify("No valid URL in selection", vim.log.levels.WARN)
  end
end

function M.setup_buffer_keymaps()
  local telescope = require("core.plugins.markdown.telescope")
  local task_mgmt = require("core.plugins.markdown.task-management")

  -- Project tag Telescope finders
  vim.keymap.set("n", "<leader>mp", function()
    telescope.get_tag_telescope_finder("project", true)
  end, { buffer = true, desc = "Search for 'project' tag" })

  vim.keymap.set("n", "<leader>mc", function()
    telescope.get_tag_telescope_finder("current-project", true)
  end, { buffer = true, desc = "Search for 'current-project' tag" })

  vim.keymap.set("n", "<leader>mf", function()
    telescope.get_tag_telescope_finder("finished-project", true)
  end, { buffer = true, desc = "Search for 'finished-project' tag" })

  vim.keymap.set("n", "<leader>mn", function()
    telescope.get_tag_telescope_finder("next-project", true)
  end, { buffer = true, desc = "Search for 'next-project' tag" })

  vim.keymap.set("n", "<leader>md", function()
    telescope.get_tag_telescope_finder("defered-project", true)
  end, { buffer = true, desc = "Search for 'defered-project' tag" })

  -- Tag search keymaps
  vim.keymap.set(
    "n",
    "<leader>kt",
    telescope.pick_tag_and_search,
    { buffer = true, desc = "Pick tag and search" }
  )

  vim.keymap.set(
    "n",
    "<leader>ta",
    telescope.pick_task_tag_and_search,
    { buffer = true, desc = "Pick task tag and search" }
  )
  vim.keymap.set("n", "<leader>tn", function()
    telescope.search_tasks_with_tag("_next")
  end, { buffer = true, desc = "Search tasks with tag _next" })

  -- Text formatting keymaps
  vim.keymap.set(
    "n",
    "<leader>mb",
    toggle_bullet_point,
    { buffer = true, desc = "Toggle bullet point (dash)" }
  )
  vim.keymap.set(
    "n",
    "<leader>ml",
    toggle_todo_checkbox,
    { buffer = true, desc = "Toggle todo (dash)" }
  )

  -- Navigation keymaps
  jump_to_header("To Do", "<leader>mt", "Jump to To Do section")
  jump_to_header("Notes", "<leader>mn", "Jump to Notes section")

  -- Link handling
  vim.keymap.set(
    "n",
    "<leader>mo",
    open_markdown_link,
    { buffer = true, desc = "Open markdown link in browser" }
  )
  vim.keymap.set(
    "v",
    "<leader>mo",
    open_selected_markdown_link,
    { buffer = true, desc = "Open selected markdown link in browser" }
  )

   -- Task management
   vim.keymap.set(
     "n",
     "<localleader>d",
     function()
       task_mgmt.toggle_task_state("forward")
     end,
     { buffer = true, desc = "Toggle task state forward (blank → progress → done → blank)" }
   )
   vim.keymap.set(
     "n",
     "<localleader>D",
     function()
       task_mgmt.toggle_task_state("backward")
     end,
     { buffer = true, desc = "Toggle task state backward (blank → done → progress → blank)" }
   )

  -- Diary note keymaps
  vim.keymap.set("n", "<leader>dh", function()
    local today = os.date("%Y-%m-%d", os.time())
    open_diary_note_for_date(today)
  end, { buffer = true, desc = "Open today's diary note" })

  vim.keymap.set("n", "<leader>da", function()
    local yesterday = os.date("%Y-%m-%d", os.time() - 24 * 60 * 60)
    open_diary_note_for_date(yesterday)
  end, { buffer = true, desc = "Open yesterday's diary note" })

  vim.keymap.set("n", "<leader>dm", function()
    local tomorrow = os.date("%Y-%m-%d", os.time() + 24 * 60 * 60)
    open_diary_note_for_date(tomorrow)
  end, { buffer = true, desc = "Open tomorrow's diary note" })

  vim.keymap.set("n", "<leader>dc", function()
    vim.ui.input({ prompt = "Enter date (YYYY-MM-DD): " }, function(input)
      if input and input:match("^%d%d%d%d%-%d%d%-%d%d$") then
        open_diary_note_for_date(input)
      else
        vim.notify("Invalid date format. Use YYYY-MM-DD.", vim.log.levels.ERROR)
      end
    end)
  end, { buffer = true, desc = "Open diary note for custom date" })

  -- Task search keymaps
  vim.keymap.set(
    "n",
    "<leader>tc",
    telescope.search_completed_tasks,
    { buffer = true, desc = "Search for completed tasks" }
  )
  vim.keymap.set(
    "n",
    "<leader>ti",
    telescope.search_progress_tasks,
    { buffer = true, desc = "Search for tasks in progress" }
  )
  vim.keymap.set(
    "n",
    "<leader>tt",
    telescope.search_incomplete_tasks,
    { buffer = true, desc = "Search for incomplete tasks" }
  )

  -- Create task with tags
  vim.keymap.set(
    "n",
    "<leader>aa",
    create_task_with_tags,
    { buffer = true, desc = "Create task with selected tags" }
  )
  vim.keymap.set(
    "n",
    "<leader>ae",
    modify_task_tags,
    { buffer = true, desc = "Modify tags on current task" }
  )
  vim.keymap.set(
    "i",
    "<C-y>",
    create_task_with_tags,
    { buffer = true, desc = "Create task with selected tags" }
  )
  vim.keymap.set(
    "i",
    "<C-g>",
    modify_task_tags,
    { buffer = true, desc = "Modify tags on current task" }
  )

  -- Spell language selection
  vim.keymap.set("n", "<leader>msl", function()
    local current = vim.opt.spelllang:get()[1] or ""
    vim.ui.input(
      { prompt = "Set spelllang (comma-separated): ", default = current },
      function(input)
        if input and input ~= "" then
          vim.opt.spelllang = input
          vim.notify("Set spelllang to: " .. input, vim.log.levels.INFO)
        end
      end
    )
  end, { buffer = true, desc = "Set/change spell languages" })

  -- bookmark mappings
  vim.keymap.set(
    "n",
    "<leader>mbm",
    open_random_bookmark_note,
    { buffer = true, desc = "Open random bookmark note" }
  )
  vim.keymap.set(
    "n",
    "<leader>mo",
    open_markdown_link,
    { buffer = true, desc = "Open markdown link in browser" }
  )
  vim.keymap.set(
    "n",
    "<leader>mbu",
    open_bookmark_url,
    { buffer = true, desc = "Open bookmark URL" }
  )

  -- Weekly note keymaps
  vim.keymap.set("n", "<leader>msh", function()
    local today = os.date("%Y-%m-%d", os.time())
    open_weekly_note_for_date(today)
  end, { buffer = true, desc = "Open this week's note" })

  vim.keymap.set("n", "<leader>msa", function()
    local last_week = os.date("%Y-%m-%d", os.time() - 7 * 24 * 60 * 60)
    open_weekly_note_for_date(last_week)
  end, { buffer = true, desc = "Open last week's note" })

  vim.keymap.set("n", "<leader>msm", function()
    local next_week = os.date("%Y-%m-%d", os.time() + 7 * 24 * 60 * 60)
    open_weekly_note_for_date(next_week)
  end, { buffer = true, desc = "Open next week's note" })
end

return M
