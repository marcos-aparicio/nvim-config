local M = {}

function M.toggle_task_state(direction)
  direction = direction or "forward"
  local label_done = "#_done"
  local label_progress = "#_progress"
  local tasks_heading = "## Completed tasks"
  local timestamp = os.date("%y%m%d-%H%M")

  vim.cmd("mkview")

  local api = vim.api
  local buf = api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local start_line = cursor_pos[1] - 1
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local total_lines = #lines

  if start_line >= total_lines then
    vim.cmd("loadview")
    return
  end

  -- Helper function to find heading using Treesitter
  local function find_heading_by_treesitter(heading_text)
    local parser = vim.treesitter.get_parser(buf, "markdown")
    if not parser then
      return nil
    end

    local tree = parser:parse()[1]
    local root = tree:root()

    -- Query for ATX level 2 headings
    local query = vim.treesitter.query.parse(
      "markdown",
      [[
      (atx_heading
        (atx_h2_marker)
        (inline) @content
      ) @heading
    ]]
    )

    for id, node in query:iter_captures(root, buf, 0, -1) do
      local name = query.captures[id]
      if name == "content" then
        local text = vim.treesitter.get_node_text(node, buf)
        if text:match(heading_text:gsub("##%s*", "")) then
          local parent = node:parent()
          if parent then
            local start_row, _, _, _ = parent:range()
            return start_row
          end
        end
      end
    end
    return nil
  end

  -- Find the start of the bullet point using Treesitter
  local function find_task_chunk()
    local parser = vim.treesitter.get_parser(buf, "markdown")
    if not parser then
      -- Fallback to original logic if Treesitter is not available
      local chunk_start = start_line
      while chunk_start > 0 do
        local line_text = lines[chunk_start + 1]
        if line_text == "" or line_text:match("^%s*%-") then
          break
        end
        chunk_start = chunk_start - 1
      end

      if lines[chunk_start + 1] == "" and chunk_start < (total_lines - 1) then
        chunk_start = chunk_start + 1
      end

      return chunk_start
    end

    local tree = parser:parse()[1]
    local root = tree:root()

    -- Query for list items
    local query = vim.treesitter.query.parse(
      "markdown",
      [[
      (list_item
        (task_list_marker_checked)
      ) @task_item
      (list_item
        (task_list_marker_unchecked)
      ) @task_item
    ]]
    )

    for _, node in query:iter_captures(root, buf, 0, -1) do
      local start_row, _, _, _ = node:range()
      -- Fix: match only if cursor is on the first line of the list item
      if start_line == start_row then
        return start_row
      end
    end

    -- Fallback to original logic
    local chunk_start = start_line
    while chunk_start > 0 do
      local line_text = lines[chunk_start + 1]
      if line_text == "" or line_text:match("^%s*%-") then
        break
      end
      chunk_start = chunk_start - 1
    end

    if lines[chunk_start + 1] == "" and chunk_start < (total_lines - 1) then
      chunk_start = chunk_start + 1
    end

    return chunk_start
  end

  local chunk_start = find_task_chunk()
  local bullet_line = lines[chunk_start + 1]

  if not bullet_line:match("^%s*%- %[[x %-%]]") then
    print("Not a task bullet: no action taken.")
    vim.cmd("loadview")
    return
  end

  -- Find the end of the chunk
  local chunk_end = chunk_start
  while chunk_end + 1 < total_lines do
    local next_line = lines[chunk_end + 2]
    if next_line == "" or next_line:match("^%s*%-") then
      break
    end
    chunk_end = chunk_end + 1
  end

  -- Extract the chunk
  local chunk = {}
  for i = chunk_start, chunk_end do
    table.insert(chunk, lines[i + 1])
  end

  local function removeLabel(line)
    return line
      :gsub("%s+#_progress", "")
      :gsub("%s+#_done%s+%d%d%d%d%d%d%-%d%d%d%d", "")
      :gsub("%s+`untoggled`", "")
  end

  local function insertLabelAfterCheckbox(line, label)
    return line:gsub("^(%s*%- %[[x %-]%]%s*)", "%1" .. label .. " ")
  end

  local function getState(line)
    if line:match("^%s*%- %[ %]") then
      return "blank"
    elseif line:match("^%s*%- %[%-%]") then
      return "progress"
    elseif line:match("^%s*%- %[x%]") then
      return "done"
    else
      return nil
    end
  end

  -- Helper function to move chunk to completed section
  local function moveToCompleted()
    for i = chunk_end, chunk_start, -1 do
      table.remove(lines, i + 1)
    end

    local heading_index = find_heading_by_treesitter(tasks_heading)
    if heading_index then
      heading_index = heading_index + 1
      for _, cLine in ipairs(chunk) do
        table.insert(lines, heading_index + 1, cLine)
        heading_index = heading_index + 1
      end
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
  end

   -- Define task state cycles
    -- Define task state cycles
    local stateCycles = {
      forward = { "blank", "progress", "done" },   -- blank → progress → done → blank
      backward = { "blank", "done", "progress" },  -- blank → done → progress → blank
    }

    -- Define state properties - what each state is and how to handle it
    local states = {
      blank = {
        checkbox = "[ ]",
        label = "",
        sub_transforms = function()
          for i = 1, #chunk do
            chunk[i] = chunk[i]:gsub("%s+#_progress", "")
            chunk[i] = chunk[i]:gsub("%s+#_done%s+%d%d%d%d%d%d%-%d%d%d%d", "")
            chunk[i] = chunk[i]:gsub("%s+`untoggled`", "")
          end
        end,
        isLocal = true,
      },
      progress = {
        checkbox = "[-]",
        label = label_progress,
        sub_transforms = function()
          for i = 1, #chunk do
            chunk[i] = chunk[i]:gsub("%- %[%-%#_progress%]", label_progress)
            chunk[i] = chunk[i]:gsub("%s+#_done%s+%d%d%d%d%d%d%-%d%d%d%d", label_done)
            chunk[i] = chunk[i]:gsub("%s+`untoggled`", "")
          end
        end,
        isLocal = true,
      },
      done = {
        checkbox = "[x]",
        label = label_done .. " " .. timestamp,
        sub_transforms = function()
          for i = 1, #chunk do
            chunk[i] = chunk[i]:gsub("%s+#_done%s+%d%d%d%d%d%d%-%d%d%d%d", " " .. label_done .. " " .. timestamp)
            chunk[i] = chunk[i]:gsub("%s+#_progress", label_progress)
            chunk[i] = chunk[i]:gsub("%s+`untoggled`", "")
          end
        end,
        isLocal = false,
      },
    }

    local currentState = getState(chunk[1])

    -- Find next state based on direction and current state
    local cycle = stateCycles[direction]
    if not cycle or not currentState then
      vim.notify(
        currentState and "Invalid direction. Use 'forward' or 'backward'" or "Unknown task state",
        vim.log.levels.WARN
      )
      vim.cmd("loadview")
      return
    end

    local currentIndex = nil
    for i, s in ipairs(cycle) do
      if s == currentState then
        currentIndex = i
        break
      end
    end

    if not currentIndex then
      vim.notify("State not found in cycle", vim.log.levels.WARN)
      vim.cmd("loadview")
      return
    end

    -- Get next state (wraps around)
    local nextIndex = (currentIndex % #cycle) + 1
    local nextState = cycle[nextIndex]
    local nextStateInfo = states[nextState]

    -- Apply transformation to checkbox
    local function setCheckbox(line, checkbox)
      return line:gsub("^(%s*%- )%[[x %-]%]", "%1" .. checkbox)
    end

    chunk[1] = removeLabel(chunk[1])
    chunk[1] = setCheckbox(chunk[1], nextStateInfo.checkbox)
    if nextStateInfo.label ~= "" then
      chunk[1] = insertLabelAfterCheckbox(chunk[1], nextStateInfo.label)
    end
    nextStateInfo.sub_transforms()

    if nextStateInfo.isLocal then
      vim.api.nvim_buf_set_lines(buf, chunk_start, chunk_end + 1, false, chunk)
    else
      moveToCompleted()
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    end

    -- Create notification message
    local notificationMap = {
      forward = {
        blank = "Marked as In Progress",
        progress = "Completed",
        done = "Untoggled",
      },
      backward = {
        blank = "Removed from progress",
        progress = "Marked as Blank",
        done = "Marked as In Progress (backward)",
      },
    }
    local notification = notificationMap[direction][currentState]
    vim.notify(notification, vim.log.levels.INFO)

  vim.cmd("silent update")
  vim.cmd("loadview")
end

return M
