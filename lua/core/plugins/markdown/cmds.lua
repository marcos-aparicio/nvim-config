local M = {}

local function convert_selection_with_pandoc()
  -- Check if pandoc is available
  if vim.fn.executable("pandoc") == 0 then
    vim.notify("pandoc is not installed or not in PATH", vim.log.levels.ERROR)
    return
  end

  -- Get the selected text
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)

  if #lines == 0 then
    vim.notify("No text selected", vim.log.levels.WARN)
    return
  end

  -- Handle partial line selection
  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
  else
    lines[1] = string.sub(lines[1], start_pos[3])
    lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
  end

  local selected_text = table.concat(lines, "\n")

  -- Prompt for target format
  vim.ui.input({
    prompt = "Convert to format (e.g., html, latex, docx, rst): ",
    default = "html"
  }, function(target_format)
    if not target_format or target_format == "" then
      vim.notify("No format specified", vim.log.levels.WARN)
      return
    end

    -- Create temporary file for input
    local temp_file = vim.fn.tempname() .. ".md"
    vim.fn.writefile(vim.split(selected_text, "\n"), temp_file)

    -- Run pandoc conversion
    local cmd = { "pandoc", "-f", "markdown", "-t", target_format, temp_file }

    vim.fn.jobstart(cmd, {
      stdout_buffered = true,
      on_stdout = function(_, data)
        if data and #data > 0 then
          local output = table.concat(data, "\n")
          -- Remove the last empty line if it exists
          output = output:gsub("\n$", "")

          -- Copy to clipboard
          vim.fn.setreg("+", output)
          vim.notify("Converted to " .. target_format .. " and copied to clipboard", vim.log.levels.INFO)
        end
      end,
      on_stderr = function(_, data)
        if data and #data > 0 then
          local error_msg = table.concat(data, "\n")
          vim.notify("Pandoc error: " .. error_msg, vim.log.levels.ERROR)
        end
      end,
      on_exit = function(_, code)
        -- Clean up temporary file
        vim.fn.delete(temp_file)

        if code ~= 0 then
          vim.notify("Pandoc conversion failed with exit code " .. code, vim.log.levels.ERROR)
        end
      end
    })
  end)
end

function M.setup_buffer_commands()
  -- Create user command for pandoc conversion
  vim.api.nvim_buf_create_user_command(0, "MarkdownConvertSelection", convert_selection_with_pandoc, {
    desc = "Convert selected markdown text to another format using pandoc and copies it to the clipboard",
    range = true
  })
end

return M
