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

-- Get all list files sorted by name
local function get_list_files(lists_dir)
  local files = {}

  if vim.fn.isdirectory(lists_dir) == 0 then
    return files
  end

  -- Use vim.fn.glob to get all .md files
  local glob_pattern = lists_dir .. "/*.md"
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

-- Regenerate the lists.md index
function M.regenerate_index()
  local root = diary.find_obsidian_root()
  if not root then
    vim.notify("Could not find .obsidian directory in parent folders", vim.log.levels.ERROR)
    return
  end

  local lists_dir = root .. "/lists"
  local indexes_dir = root .. "/indexes"
  local index_file = indexes_dir .. "/lists.md"

  if vim.fn.isdirectory(lists_dir) == 0 then
    vim.fn.mkdir(lists_dir, "p")
  end

  if vim.fn.isdirectory(indexes_dir) == 0 then
    vim.fn.mkdir(indexes_dir, "p")
  end

  local list_files = get_list_files(lists_dir)

  -- Build index content
  local lines = { "# Lists Index", "" }

  for _, file in ipairs(list_files) do
    local title = get_h1_from_file(file.path)
    if title then
      table.insert(lines, string.format("[[%s]]", title))
    else
      -- Fallback to basename if no H1 found
      table.insert(lines, string.format("[[%s]]", file.basename))
    end
  end

  -- Write to index file
  vim.fn.writefile(lines, index_file)
end

-- Regenerate the tickler.md index
function M.regenerate_tickler_index()
  local root = diary.find_obsidian_root()
  if not root then
    vim.notify("Could not find .obsidian directory in parent folders", vim.log.levels.ERROR)
    return
  end

  local tickler_dir = root .. "/lists/tickler"
  local indexes_dir = root .. "/indexes"
  local index_file = indexes_dir .. "/tickler.md"

  if vim.fn.isdirectory(tickler_dir) == 0 then
    vim.fn.mkdir(tickler_dir, "p")
  end

  if vim.fn.isdirectory(indexes_dir) == 0 then
    vim.fn.mkdir(indexes_dir, "p")
  end

  local tickler_files = get_list_files(tickler_dir)

  -- Build index content
  local lines = { "# Tickler Index", "" }

  for _, file in ipairs(tickler_files) do
    local title = get_h1_from_file(file.path)
    if title then
      table.insert(lines, string.format("[[%s]]", title))
    else
      -- Fallback to basename if no H1 found
      table.insert(lines, string.format("[[%s]]", file.basename))
    end
  end

  -- Write to index file
  vim.fn.writefile(lines, index_file)
end

return M

