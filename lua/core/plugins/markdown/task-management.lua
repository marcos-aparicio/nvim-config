local M = {}

function M.toggle_task_state()
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
    local parser = vim.treesitter.get_parser(buf, 'markdown')
    if not parser then
      return nil
    end

    local tree = parser:parse()[1]
    local root = tree:root()

    -- Query for ATX level 2 headings
    local query = vim.treesitter.query.parse('markdown', [[
      (atx_heading
        (atx_h2_marker)
        (inline) @content
      ) @heading
    ]])

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
    local parser = vim.treesitter.get_parser(buf, 'markdown')
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
    local query = vim.treesitter.query.parse('markdown', [[
      (list_item
        (task_list_marker_checked)
      ) @task_item
      (list_item
        (task_list_marker_unchecked)
      ) @task_item
    ]])

    for id, node in query:iter_captures(root, buf, 0, -1) do
      local start_row, _, end_row, _ = node:range()
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

  -- Helper functions for state manipulation
  local function bulletToBlank(line)
    return line:gsub("^(%s*%- )%[[x%-]%]", "%1[ ]")
  end

  local function bulletToProgress(line)
    return line:gsub("^(%s*%- )%[[x ]%]", "%1[-]")
  end

  local function bulletToX(line)
    return line:gsub("^(%s*%- )%[[ %-]%]", "%1[x]")
  end

  local function removeLabel(line)
    return line:gsub("%s+#_progress", ""):gsub("%s+#_done%s+%d%d%d%d%d%d%-%d%d%d%d", ""):gsub("%s+`untoggled`", "")
  end

  local function insertLabelAfterCheckbox(line, label)
    return line:gsub("^(%s*%- %[[x %-]%]%s*)", "%1" .. label .. " ")
  end

  local function insertDoneLabelWithDate(line, label, date)
    return line:gsub("^(%s*%- %[x%]%s*)", "%1" .. label .. " " .. date .. " ")
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

  local state = getState(chunk[1])

  if state == "blank" then
    chunk[1] = bulletToProgress(chunk[1])
    chunk[1] = removeLabel(chunk[1])
    chunk[1] = insertLabelAfterCheckbox(chunk[1], label_progress)

    for i = 2, #chunk do
      chunk[i] = chunk[i]:gsub("%- %[%-%#_progress%]", label_progress)
      chunk[i] = chunk[i]:gsub("%s+#_done%s+%d%d%d%d%d%d%-%d%d%d%d", label_done)
      chunk[i] = chunk[i]:gsub("%s+`untoggled`", "")
    end

    vim.api.nvim_buf_set_lines(buf, chunk_start, chunk_end + 1, false, chunk)
    vim.notify("Marked as In Progress", vim.log.levels.INFO)

  elseif state == "progress" then
    chunk[1] = bulletToX(chunk[1])
    chunk[1] = removeLabel(chunk[1])
    chunk[1] = insertDoneLabelWithDate(chunk[1], label_done, timestamp)

    for i = 2, #chunk do
      chunk[i] = chunk[i]:gsub("%s+#_done%s+%d%d%d%d%d%d%-%d%d%d%d", label_done .. " " .. timestamp)
      chunk[i] = chunk[i]:gsub("%s+#_progress", label_progress)
      chunk[i] = chunk[i]:gsub("%s+`untoggled`", "")
    end

    -- Move chunk to completed section using Treesitter
    for i = chunk_end, chunk_start, -1 do
      table.remove(lines, i + 1)
    end

    local heading_index = find_heading_by_treesitter(tasks_heading)

    if heading_index then
      -- Convert to 1-based indexing for table operations
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

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.notify("Completed", vim.log.levels.INFO)

  elseif state == "done" then
    chunk[1] = bulletToBlank(chunk[1])
    chunk[1] = removeLabel(chunk[1])
    chunk[1] = insertLabelAfterCheckbox(chunk[1], "`untoggled`")

    for i = 2, #chunk do
      chunk[i] = chunk[i]:gsub("%s+#_progress", label_progress)
      chunk[i] = chunk[i]:gsub("%s+#_done%s+%d%d%d%d%d%d%-%d%d%d%d", label_done)
      chunk[i] = chunk[i]:gsub("%s+`untoggled`", "")
    end

    vim.api.nvim_buf_set_lines(buf, chunk_start, chunk_end + 1, false, chunk)
    vim.notify("Untoggled", vim.log.levels.INFO)
  else
    vim.notify("Unknown task state", vim.log.levels.WARN)
  end

  vim.cmd("silent update")
  vim.cmd("loadview")
end

return M
