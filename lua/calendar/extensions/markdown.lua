local markdown = {}

local diary = require("core.plugins.markdown.diary")

markdown.get = function(year, month)
  return {}
end

markdown.actions = {
  open_diary = function(year, month, day)
    if year and month and day then
      local date_string = string.format("%04d-%02d-%02d", year, month, day)
      vim.cmd("q")  -- Close the calendar first
      vim.schedule(function()
        diary.open_diary_note_for_date(date_string)
      end)
    else
      vim.notify("Error: Missing year, month, or day values", vim.log.levels.WARN)
    end
  end,
}

return markdown
