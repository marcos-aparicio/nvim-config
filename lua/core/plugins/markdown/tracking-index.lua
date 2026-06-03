local M = {}

local diary = require("core.plugins.markdown.diary")

-- Extract H1 title from a markdown file
local function get_h1_from_file(filepath)
  if vim.fn.filereadable(filepath) == 0 then
    return nil
  end

  local lines = vim.fn.readfile(filepath)
  for _, line in ipairs(lines) do
    local title = line:match("^#%s+(.+)$")
    if title then
      return title
    end
  end

  return nil
end

-- Get all tracking files sorted by name
local function get_tracking_files(tracking_dir)
  local files = {}

  if vim.fn.isdirectory(tracking_dir) == 0 then
    return files
  end

  -- Use vim.fn.glob to get all .md files
  local glob_pattern = tracking_dir .. "/*.md"
  local file_list = vim.fn.glob(glob_pattern, false, true)

  for _, filepath in ipairs(file_list) do
    local filename = vim.fn.fnamemodify(filepath, ":t")
    table.insert(files, {
      path = filepath,
      filename = filename,
      basename = filename:gsub("%.md$", ""),
    })
  end

  -- Sort by filename
  table.sort(files, function(a, b)
    return a.filename < b.filename
  end)

  return files
end

-- Regenerate the tracking.md index
function M.regenerate_index()
  local root = diary.find_obsidian_root()
  if not root then
    vim.notify("Could not find .obsidian directory in parent folders", vim.log.levels.ERROR)
    return
  end

  local tracking_dir = root .. "/tracking"
  local indexes_dir = root .. "/indexes"
  local index_file = indexes_dir .. "/tracking.md"

  if vim.fn.isdirectory(tracking_dir) == 0 then
    vim.fn.mkdir(tracking_dir, "p")
  end

  if vim.fn.isdirectory(indexes_dir) == 0 then
    vim.fn.mkdir(indexes_dir, "p")
  end

  local tracking_files = get_tracking_files(tracking_dir)

  -- Create a map of current file titles for quick lookup
  local current_titles = {}
  for _, file in ipairs(tracking_files) do
    local title = get_h1_from_file(file.path) or file.basename
    current_titles[title] = true
  end

  -- Build index content by reading existing file and updating it
  local lines = {}
  local in_other_section = false
  local other_section_start_idx = nil
  local found_other_section = false

  if vim.fn.filereadable(index_file) == 1 then
    local original_lines = vim.fn.readfile(index_file)

    for i, line in ipairs(original_lines) do
      -- Keep the header
      if line:match("^#%s+Tracking Index") then
        table.insert(lines, line)
        goto continue
      end

      -- Detect "Other Tracking" section
      if line:match("^## Other Tracking") then
        found_other_section = true
        other_section_start_idx = #lines + 1
        table.insert(lines, line)
        goto continue
      end

      -- If we're in "Other Tracking" section, collect new items later
      if found_other_section and (line == "" or line:match("^%[%[")) then
        if line == "" then
          goto continue
        end
        -- We'll rebuild this section, skip it for now
        goto continue
      end

      -- Check if it's a wiki link
      local title = line:match("^%[%[(.+)%]%]$")
      if title then
        -- Keep it only if the file still exists
        if current_titles[title] then
          table.insert(lines, line)
        end
        -- If it doesn't exist, skip it (removal)
      else
        -- Keep empty lines and other content (but not from Other Tracking section)
        if not found_other_section or i <= (other_section_start_idx or 0) then
          table.insert(lines, line)
        end
      end

      ::continue::
    end
  else
    -- File doesn't exist, create from scratch
    table.insert(lines, "# Tracking Index")
    table.insert(lines, "")
  end

  -- Now find all new/untracked items
  local new_tracking_items = {}
  local existing_in_file = {}

  -- Collect existing links from the file
  for _, line in ipairs(lines) do
    local title = line:match("^%[%[(.+)%]%]$")
    if title then
      existing_in_file[title] = true
    end
  end

  -- Find new tracking items
  for _, file in ipairs(tracking_files) do
    local title = get_h1_from_file(file.path) or file.basename
    if not existing_in_file[title] then
      table.insert(new_tracking_items, string.format("[[%s]]", title))
    end
  end

  -- Add "Other Tracking" section if there are new items
  if #new_tracking_items > 0 then
    -- Remove old "Other Tracking" section if it exists
    local new_lines = {}
    local skip_other_section = false
    for _, line in ipairs(lines) do
      if line:match("^## Other Tracking") then
        skip_other_section = true
        goto skip
      end
      if skip_other_section and line ~= "" and not line:match("^%[%[") then
        skip_other_section = false
      end
      if not skip_other_section then
        table.insert(new_lines, line)
      end
      ::skip::
    end

    lines = new_lines

    -- Add new "Other Tracking" section
    if #lines > 0 and lines[#lines] ~= "" then
      table.insert(lines, "")
    end
    table.insert(lines, "## Other Tracking")
    table.insert(lines, "")
    for _, item in ipairs(new_tracking_items) do
      table.insert(lines, item)
    end
  end

  -- Write to index file
  vim.fn.writefile(lines, index_file)
end

return M
