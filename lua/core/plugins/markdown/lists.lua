local M = {}

local collections = require("core.plugins.markdown.collections")
local diary = require("core.plugins.markdown.diary")

-- Convenience function to open specific list file
local function open_list_file(filename)
  collections.open_file("lists", filename)
end

-- Open next.md
function M.open_next()
  open_list_file("next.md")
end

-- Open someday-maybe.md
function M.open_someday_maybe()
  open_list_file("someday-maybe.md")
end

-- Open inbox.md
function M.open_inbox()
  open_list_file("inbox.md")
end

-- Open waiting-to.md
function M.open_waiting_to()
  open_list_file("waiting-to.md")
end

-- Open tickler.md
function M.open_tickler()
  open_list_file("tickler.md")
end

-- Open lists directory with telescope finder
function M.open_lists_telescope()
  collections.open_telescope("lists")
end

-- Create a new list with automatic name transformation
function M.create_new_list()
  collections.create_new_entry("lists")
end

-- Append item to inbox list
function M.append_to_inbox()
  local root = diary.find_obsidian_root()
  if not root then
    vim.notify("Could not find .obsidian directory in parent folders", vim.log.levels.ERROR)
    return
  end

  local lists_dir = root .. "/lists"
  local inbox_path = lists_dir .. "/inbox.md"

  vim.ui.input({ prompt = "Add to inbox: " }, function(input)
    if not input or input:match("^%s*$") then
      return
    end

    -- Read current inbox content
    local lines = {}
    if vim.fn.filereadable(inbox_path) == 1 then
      lines = vim.fn.readfile(inbox_path)
    else
      -- Create inbox if it doesn't exist
      lines = { "# inbox", "" }
    end

     -- Append the new item with date
     local date_str = os.date("%c")
     table.insert(lines, "- (" .. date_str .. ") " .. input)

    -- Write back to file
    vim.fn.writefile(lines, inbox_path)
    vim.notify("Added to inbox: " .. input, vim.log.levels.INFO)
  end)
end

return M
