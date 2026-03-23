local M = {}

local diary = require("core.plugins.markdown.diary")

-- Open a specific list file
local function open_list_file(filename)
  local root = diary.find_obsidian_root()
  if not root then
    vim.notify("Could not find .obsidian directory in parent folders", vim.log.levels.ERROR)
    return
  end

  local lists_dir = root .. "/lists"
  
  -- Create lists directory if it doesn't exist
  if vim.fn.isdirectory(lists_dir) == 0 then
    vim.fn.mkdir(lists_dir, "p")
  end

  local file_path = lists_dir .. "/" .. filename
  
  -- Create file if it doesn't exist
  if vim.fn.filereadable(file_path) == 0 then
    vim.fn.writefile({}, file_path)
  end

  vim.cmd("edit " .. vim.fn.fnameescape(file_path))
end

-- Open next.md
function M.open_next()
  open_list_file("next.md")
end

-- Open someday-maybe.md
function M.open_someday_maybe()
  open_list_file("someday-maybe.md")
end

return M
