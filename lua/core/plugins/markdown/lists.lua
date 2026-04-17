local M = {}

local diary = require("core.plugins.markdown.diary")
local lists_index = require("core.plugins.markdown.lists-index")

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

  local telescope = require("telescope.builtin")
  telescope.find_files({
    cwd = lists_dir,
    prompt_title = "Lists",
  })
end

-- Create a new list with automatic name transformation
function M.create_new_list()
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

  vim.ui.input({ prompt = "Enter list name: " }, function(input)
    if not input or input:match("^%s*$") then
      vim.notify("List name cannot be empty", vim.log.levels.WARN)
      return
    end

    -- Transform name: trim, convert to lowercase, replace spaces with dashes
    local list_name = vim.trim(input):lower():gsub("%s+", "-")
    local filename = list_name .. ".md"
    local file_path = lists_dir .. "/" .. filename

    -- Check if file already exists
    if vim.fn.filereadable(file_path) == 1 then
      vim.notify("List '" .. filename .. "' already exists", vim.log.levels.WARN)
      return
    end

    -- Create file with h1 header
    local h1_title = input:gsub("^%s+", ""):gsub("%s+$", "") -- Trim the original input
    local content = { "# " .. h1_title, "" }
    vim.fn.writefile(content, file_path)

    -- Open the newly created file
    vim.cmd("edit " .. vim.fn.fnameescape(file_path))
    vim.notify("Created list: " .. filename, vim.log.levels.INFO)

    -- Regenerate index
    lists_index.regenerate_index()
  end)
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
