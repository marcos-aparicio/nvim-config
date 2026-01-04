local NS = vim.api.nvim_create_namespace("datediff")
local pattern = "`=%s*date%(.-%) %- date%(%d%d%d%d%-%d%d%-%d%d%)`"

-- Find all parts of lines that match a pattern in the current buffer
local function get_matching_parts(pattern)
  local bufnr = vim.api.nvim_get_current_buf()
  local total_lines = vim.api.nvim_buf_line_count(bufnr)
  local matching_parts = {}
  for i = 1, total_lines do
    local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
    for match in string.gmatch(line, pattern) do
      table.insert(matching_parts, { line_num = i, match_text = match })
    end
  end
  return matching_parts
end

-- Extract all content inside parentheses from a string
local function get_dates(input_string)
  local pattern = "%((.-)%)"
  local matching_content = {}
  for match in string.gmatch(input_string, pattern) do
    table.insert(matching_content, match)
  end
  return matching_content
end

-- parses the date strings into date tables
local function parse_date(str)
  if str == "today" then
    local now = os.date("*t")
    return os.time({ year = now.year, month = now.month, day = now.day })
  end
  local y, m, d = str:match("(%d%d%d%d)%-(%d%d)%-(%d%d)")
  if y and m and d then
    return os.time({ year = tonumber(y), month = tonumber(m), day = tonumber(d) })
  end
  return nil
end

--- Calculates the difference between two dates and returns a human-readable string.
-- The function expects a table with two date strings. It computes the difference in years, months, weeks, and days.
-- Dates should be in a format supported by `parse_date`.
-- If the first date is older than the second, the order is swapped automatically.
-- Returns "Invalid date(s)" if either date cannot be parsed.
-- @param dates table: A table containing two date strings {newest, oldest}.
-- @return string: A string describing the difference (e.g., "2 year(s), 3 month(s), 1 week(s), 4 day(s)").
local function datediff_lua(dates)
  local newest = dates[1]
  local oldest = dates[2]
  local t_newest = parse_date(newest)
  local t_oldest = parse_date(oldest)
  if not t_newest or not t_oldest then
    return "Invalid date(s)"
  end
  if t_oldest > t_newest then
    t_oldest, t_newest = t_newest, t_oldest
  end

  local d1 = os.date("*t", t_oldest)
  local d2 = os.date("*t", t_newest)

  -- Calculate total days difference
  -- local total_days = os.difftime(t_newest, t_oldest) // (24 * 60 * 60)

  -- Calculate years
  local years = d2.year - d1.year
  local months = d2.month - d1.month
  local days = d2.day - d1.day

  if days < 0 then
    months = months - 1
    -- Get days in previous month
    local prev_month = d2.month - 1
    local prev_year = d2.year
    if prev_month == 0 then
      prev_month = 12
      prev_year = prev_year - 1
    end
    -- Get days in previous month
    local days_in_prev_month =
      os.date("*t", os.time({ year = prev_year, month = prev_month + 1, day = 0 })).day
    days = days + days_in_prev_month -- just for completeness, never actually used
  end

  if months < 0 then
    years = years - 1
    months = months + 12
  end

  -- Now, recalculate days to avoid drift
  local anchor = os.time({ year = d1.year + years, month = d1.month + months, day = d1.day })
  local remaining_days = math.floor(os.difftime(t_newest, anchor) / (24 * 60 * 60))
  local weeks = math.floor(remaining_days / 7)
  local days_final = remaining_days % 7

  local parts = {}
  if years > 0 then
    table.insert(parts, years .. " year(s)")
  end
  if months > 0 then
    table.insert(parts, months .. " month(s)")
  end
  if weeks > 0 then
    table.insert(parts, weeks .. " week(s)")
  end
  if days_final > 0 or #parts == 0 then
    table.insert(parts, days_final .. " day(s)")
  end

  return table.concat(parts, ", ")
end

-- Set up autocmd for markdown files
vim.api.nvim_create_autocmd({ "BufRead", "BufWritePost" }, {
  pattern = "*.md",
  callback = function()
    local bnr = vim.fn.bufnr("%")
    local matching_parts = get_matching_parts(pattern)
    for i, match in ipairs(matching_parts) do
      local dates = get_dates(match.match_text)
      local diff = datediff_lua(dates)
      vim.api.nvim_buf_set_extmark(bnr, NS, match.line_num - 1, 0, {
        id = i,
        virt_text = { { diff, "IncSearch" } },
      })
    end
  end,
})
