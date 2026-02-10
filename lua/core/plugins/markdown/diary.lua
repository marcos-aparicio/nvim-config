local M = {}

local bookmarks_repo = os.getenv("HOME") .. "/Documents/Areas/Obsidian/bookmarks"

-- Helper function to convert Unix timestamp to French format with day of week
-- e.g., timestamp for 2026-01-28 becomes "mercredi 28 janvier 2026"
local function format_date_french(timestamp)
  local french_weekdays = {
    "dimanche", "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi"
  }
  
  local french_months = {
    "janvier", "février", "mars", "avril", "mai", "juin",
    "juillet", "août", "septembre", "octobre", "novembre", "décembre"
  }
  
  local dow = tonumber(os.date("%w", timestamp)) + 1 -- +1 because Lua tables are 1-indexed
  local day = tonumber(os.date("%d", timestamp))
  local month = tonumber(os.date("%m", timestamp))
  local year = tonumber(os.date("%Y", timestamp))
  
  return string.format("%s %d %s %d", french_weekdays[dow], day, french_months[month], year)
end

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

M.open_diary_note_for_date = function(date_str)
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
        local year, month, day = date_str:match("(%d+)%-(%d+)%-(%d+)")
        if year and month and day then
          local timestamp = os.time({ year = tonumber(year), month = tonumber(month), day = tonumber(day) })
          local french_date = format_date_french(timestamp)
          for i, line in ipairs(diary_content) do
            diary_content[i] = line:gsub("{{date:YYYY%-MM%-DD}}", date_str)
            diary_content[i] = diary_content[i]:gsub("{{date:french}}", french_date)
          end
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

M.open_weekly_note_for_date = function(date_str)
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

return M
