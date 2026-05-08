vim.api.nvim_create_user_command("MarkdownApyAddFromFile", function()
  local filetype = vim.o.filetype
  if filetype ~= "markdown" then
    vim.notify("MarkdownApyAddFromFile is only available for markdown files", vim.log.levels.WARN)
    return
  end

  local current_file = vim.fn.expand("%:p")
  vim.fn.system("apy add-from-file " .. current_file)
  vim.notify("Added: " .. current_file, vim.log.levels.INFO)
end, {
  desc = "Add current markdown file to apy (markdown only)",
})
