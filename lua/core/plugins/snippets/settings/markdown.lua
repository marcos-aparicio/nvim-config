local prequire = require("utils").prequire
local ls = prequire("luasnip")
if not ls then
  return
end

local function clipboard()
  return vim.fn.getreg("+")
end
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node

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
local function get_current_date(includeDay)
  local currentTime = os.date("*t") -- Get the current date and time as a table
  local currentMonth = currentTime.month -- Get the current month
  local currentYear = currentTime.year -- Get the current year
  local paddedMonth = string.format("%02d", currentMonth) -- Add padding to the month

  if not includeDay then
    return currentYear .. "-" .. paddedMonth
  end
  local paddedDay = string.format("%02d", currentTime.day)
  return currentYear .. "-" .. paddedMonth .. "-" .. paddedDay
end

local markdown_mappings = {
  s("todo", { t("- [ ] ") }),
  s("task", { t("* [ ] ") }),
  s("h6", { t("###### ") }),
  s("h5", { t("##### ") }),
  s("h4", { t("#### ") }),
  s("h3", { t("### ") }),
  s("h3", { t("### ") }),
  s("h2", { t("## ") }),
  s("h1", { t("# ") }),
  s("link", { t("["), i(1, "Titulo a mostrar"), t("]("), i(2, "Link pe"), t(")") }),
  s("hoy", { t(get_current_date(true)) }),
  s({
    trig = "codex:(%w+)",
    regTrig = true,
    name = "Generic code block",
    desc = "Insert a code block with dynamic language from trigger",
  }, {
    t("```"),
    f(function(_, snip)
      return snip.captures[1] or ""
    end),
    t({ "", "", "" }),
    i(1, "# code here"),
    t({ "", "", "```", "" }),
  }),
  s({
    trig = "linkex",
    name = "Paste clipboard as EXT .md link",
    desc = "Paste clipboard as EXT .md link",
  }, {
    t("["),
    i(1),
    t("]("),
    f(clipboard, {}),
    t(")"),
  }),
  s({
    trig = "callout",
    name = "Create a callout",
    desc = "Create a callout as per render-markdown.nvim",
  }, {
    t({ ">[!" }),
    c(1, {
      t("NOTE"),
      t("TIP"),
      t("IMPORTANT"),
      t("WARNING"),
      t("CAUTION"),
      t("INFO"),
      t("ABSTRACT"),
      t("TODO"),
      t("SUCCESS"),
      t("QUESTION"),
      t("FAILURE"),
      t("DANGER"),
      t("BUG"),
      t("EXAMPLE"),
      t("QUOTE"),
    }),
    t({ "]", ">", "> " }),
    i(2),
    t({ "", ">" }),
  }),
  s({
    trig = "log",
    name = "hourly log",
    desc = "Insert current time with a bullet point for stuff",
  }, {
    f(function()
      return os.date("%H:%M")
    end, {}),
    t({ "", "- " }),
  }),
}

-- ls.add_snippets("vimwiki", markdown_mappings)
ls.add_snippets("markdown", markdown_mappings)
