local prequire = require("utils").prequire
local ls = prequire("luasnip")
if not ls then
  return
end
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

--- Retrieves the current date in a formatted string.
---
--- This function returns the current date in the format "YYYY-MM-DD" if `includeDay` is set to `true`,
--- or in the format "YYYY-MM" if `includeDay` is set to `false`.
---
--- @param includeDay? boolean  A boolean flag indicating whether to include the day in the date.
---
--- @return string stringDate The current date as a formatted string.
--- @see os.date
---
local function get_current_date(includeDay, dateString)
  if not dateString then
    dateString = os.date("*t")
  end

  local currentTime = dateString -- Get the current date and time as a table
  local currentMonth = currentTime.month -- Get the current month
  local currentYear = currentTime.year -- Get the current year
  local paddedMonth = string.format("%02d", currentMonth) -- Add padding to the month

  if not includeDay then
    return currentYear .. "-" .. paddedMonth
  end
  local paddedDay = string.format("%02d", currentTime.day)
  return currentYear .. "-" .. paddedMonth .. "-" .. paddedDay
end

-- Hledger tags
ls.add_snippets("ledger", {
  s("simple", {

    t({ get_current_date(false) .. "-" }),
    i(1, "insert date"),
    t({ " " }),
    i(2, "description"),
    t({ "", "  " }),
    i(3, "first_account"),
    t({ "  " }),
    i(4, "ammount"),
    t({ "", "  " }),
    i(5, "second_account"),
  }),
  s("tod", {
    t({ get_current_date(true) }),
    t({ " " }),
    i(1, "description"),
    t({ "", "  " }),
    i(2, "first_account"),
    t({ "  " }),
    i(3, "ammount"),
    t({ "", "  " }),
    i(4, "second_account"),
  }),
  s("tod", {
    t({ get_current_date(true) }),
    t({ " " }),
    i(1, "description"),
    t({ "", "  " }),
    i(2, "first_account"),
    t({ "  " }),
    i(3, "ammount"),
    t({ "", "  " }),
    i(4, "second_account"),
  }),
  s("yes", {
    t({ get_current_date(true, os.date("*t", os.time() - 24 * 60 * 60)) }),
    t({ " " }),
    i(1, "description"),
    t({ "", "  " }),
    i(2, "first_account"),
    t({ "  " }),
    i(3, "ammount"),
    t({ "", "  " }),
    i(4, "second_account"),
  }),
})
