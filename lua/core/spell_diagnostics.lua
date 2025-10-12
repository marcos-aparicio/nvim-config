local ns = vim.api.nvim_create_namespace("spell_diagnostics")

local function spell_to_diagnostics()
  local allowed_filetypes = { markdown = true, text = true }
  local ft = vim.bo.filetype
  if not allowed_filetypes[ft] then
    vim.diagnostic.reset(ns, 0)
    return
  end
  vim.diagnostic.reset(ns, 0)
  local diagnostics = {}
  for lnum = 0, vim.api.nvim_buf_line_count(0) - 1 do
    local line = vim.api.nvim_buf_get_lines(0, lnum, lnum+1, false)[1]
    local col = 0
    while true do
      local start, finish = line:find("%w+", col+1)
      if not start then break end
      local word = line:sub(start, finish)
      if vim.fn.spellbadword(word)[1] ~= "" then
        table.insert(diagnostics, {
          lnum = lnum,
          col = start - 1,
          end_col = finish,
          severity = vim.diagnostic.severity.WARN,
          message = "Spelling: " .. word,
          source = "spell",
        })
      end
      col = finish
    end
  end
  vim.diagnostic.set(ns, 0, diagnostics, {})
end

vim.api.nvim_create_autocmd({"BufWritePost", "TextChanged", "InsertLeave"}, {
  pattern = { "*.md", "*.txt" },
  callback = spell_to_diagnostics,
})
