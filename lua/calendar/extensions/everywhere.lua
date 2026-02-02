local everywhere = {}

everywhere.get = function(year, month)
  return {}
end
everywhere.actions = {
  copy_date_to_clipboard = function(year, month, day)
    vim.notify(
      string.format(
        "year is %s month is %s and day is %s",
        year or "nil",
        month or "nil",
        day or "nil"
      )
    )
    if year and month and day then
      local date_string = string.format("%04d-%02d-%02d", year, month, day)
      vim.fn.setreg("+", date_string)
      vim.notify("Copied to clipboard: " .. date_string)
    else
      vim.notify("Error: Missing year, month, or day values", vim.log.levels.WARN)
    end
  end,
}
return everywhere
