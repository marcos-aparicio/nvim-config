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

-- Get all routine files sorted by name
local function get_routine_files(routines_dir)
  local files = {}

  if vim.fn.isdirectory(routines_dir) == 0 then
    return files
  end

  -- Use vim.fn.glob to get all .md files
  local glob_pattern = routines_dir .. "/*.md"
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

-- Regenerate the routines.md index
function M.regenerate_index()
  local root = diary.find_obsidian_root()
  if not root then
    vim.notify("Could not find .obsidian directory in parent folders", vim.log.levels.ERROR)
    return
  end

  local routines_dir = root .. "/routines"
  local indexes_dir = root .. "/indexes"
  local index_file = indexes_dir .. "/routines.md"

  if vim.fn.isdirectory(routines_dir) == 0 then
    vim.fn.mkdir(routines_dir, "p")
  end

  if vim.fn.isdirectory(indexes_dir) == 0 then
    vim.fn.mkdir(indexes_dir, "p")
  end

  local routine_files = get_routine_files(routines_dir)

  -- Create a map of current file titles for quick lookup
  local current_titles = {}
  for _, file in ipairs(routine_files) do
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
      if line:match("^#%s+Routines Index") then
        table.insert(lines, line)
        goto continue
      end

      -- Detect "Other Routines" section
      if line:match("^## Other Routines") then
        found_other_section = true
        other_section_start_idx = #lines + 1
        table.insert(lines, line)
        goto continue
      end

      -- If we're in "Other Routines" section, collect new items later
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
        -- Keep empty lines and other content (but not from Other Routines section)
        if not found_other_section or i <= (other_section_start_idx or 0) then
          table.insert(lines, line)
        end
      end

      ::continue::
    end
  else
    -- File doesn't exist, create from scratch
    table.insert(lines, "# Routines Index")
    table.insert(lines, "")
  end

  -- Now find all new/untracked routines
  local new_routine_items = {}
  local existing_in_file = {}

  -- Collect existing links from the file
  for _, line in ipairs(lines) do
    local title = line:match("^%[%[(.+)%]%]$")
    if title then
      existing_in_file[title] = true
    end
  end

  -- Find new routines
  for _, file in ipairs(routine_files) do
    local title = get_h1_from_file(file.path) or file.basename
    if not existing_in_file[title] then
      table.insert(new_routine_items, string.format("[[%s]]", title))
    end
  end

  -- Add "Other Routines" section if there are new items
  if #new_routine_items > 0 then
    -- Remove old "Other Routines" section if it exists
    local new_lines = {}
    local skip_other_section = false
    for _, line in ipairs(lines) do
      if line:match("^## Other Routines") then
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

    -- Add new "Other Routines" section
    if #lines > 0 and lines[#lines] ~= "" then
      table.insert(lines, "")
    end
    table.insert(lines, "## Other Routines")
    table.insert(lines, "")
    for _, item in ipairs(new_routine_items) do
      table.insert(lines, item)
    end
  end

  -- Write to index file
  vim.fn.writefile(lines, index_file)
end

return M
