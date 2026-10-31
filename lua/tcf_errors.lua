-- TCF correction hints: for pN.md, loads pN.errors.json from the same directory
-- and shows each error as a diagnostic (hint only). `gA` reveals the answer.
--
-- pN.errors.json format:
-- {
--   "section": "première version",          -- heading to search in (optional)
--   "errors": [
--     { "wrong": "de grandes parkings", "correct": "de grands parkings",
--       "category": "accord", "hint": "Genre de « parking » ?",
--       "rule": "parking est masculin" }
--   ]
-- }
local NS = vim.api.nvim_create_namespace("tcf_errors")

local severity_by_category = {
  accord = vim.diagnostic.severity.ERROR,
  grammaire = vim.diagnostic.severity.ERROR,
  conjugaison = vim.diagnostic.severity.ERROR,
  orthographe = vim.diagnostic.severity.ERROR,
  lexique = vim.diagnostic.severity.WARN,
  calque = vim.diagnostic.severity.WARN,
  fidelite = vim.diagnostic.severity.WARN,
  structure = vim.diagnostic.severity.HINT,
  style = vim.diagnostic.severity.HINT,
}

local function errors_file(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return nil
  end
  local path = vim.fn.fnamemodify(name, ":r") .. ".errors.json"
  if vim.fn.filereadable(path) == 1 then
    return path
  end
end

local function read_json(path)
  local ok, data = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
  end)
  if not ok then
    vim.notify("tcf_errors: invalid JSON in " .. path, vim.log.levels.ERROR)
    return nil
  end
  return data
end

-- Returns the 0-based [first, last) line range of the section titled `title`,
-- or the whole buffer when there is no title or it is not found.
local function section_range(lines, title)
  if not title then
    return 0, #lines
  end
  local first
  for i, line in ipairs(lines) do
    local heading = line:match("^#+%s*(.-)%s*$")
    if heading then
      if first then
        return first, i - 1
      end
      if heading == title then
        first = i
      end
    end
  end
  if first then
    return first, #lines
  end
  return 0, #lines
end

local function refresh(bufnr)
  local path = errors_file(bufnr)
  if not path then
    return
  end
  local data = read_json(path)
  if not data then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local diagnostics = {}
  for _, err in ipairs(data.errors or {}) do
    local first, last = section_range(lines, err.section or data.section)
    -- Errors whose text is no longer present are treated as corrected.
    for lnum = first, last - 1 do
      local s, e = lines[lnum + 1]:find(err.wrong, 1, true)
      if s then
        local category = err.category or "erreur"
        if (err.seen or 1) > 1 then
          category = string.format("%s ×%d", category, err.seen)
        end
        table.insert(diagnostics, {
          lnum = lnum,
          col = s - 1,
          end_col = e,
          severity = severity_by_category[category] or vim.diagnostic.severity.WARN,
          message = string.format("[%s] %s", category, err.hint or "Quelque chose ne va pas ici."),
          source = "tcf",
          user_data = { correct = err.correct, rule = err.rule },
        })
        break
      end
    end
  end
  vim.diagnostic.set(NS, bufnr, diagnostics)
end

local function reveal_answer()
  local lnum, col = unpack(vim.api.nvim_win_get_cursor(0))
  local diags = vim.diagnostic.get(0, { namespace = NS, lnum = lnum - 1 })
  for _, d in ipairs(diags) do
    if col >= d.col and col < d.end_col then
      local u = d.user_data or {}
      local msg = "→ " .. (u.correct or "?")
      if u.rule then
        msg = msg .. "\n" .. u.rule
      end
      vim.notify(msg, vim.log.levels.INFO, { title = "TCF" })
      return
    end
  end
  vim.notify("Pas d'erreur TCF sous le curseur", vim.log.levels.WARN)
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "TextChanged", "InsertLeave" }, {
  pattern = "*.md",
  callback = function(args)
    if not errors_file(args.buf) then
      return
    end
    refresh(args.buf)
    vim.keymap.set("n", "gA", reveal_answer, { buffer = args.buf, desc = "TCF: reveal answer" })
  end,
})
