local M = {}

--- Extract the link path from an inline markdown link at the cursor
--- Only supports: [text](path)
local function get_inline_link_at_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  -- Try to match inline link: [text](path)
  local text_start, text_end = line:find("%[([^%]]*)]%(([^)]+)%)")
  if text_start and text_end and col >= text_start and col <= text_end then
    -- Extract the path from the matched group
    local path = line:match("%[([^%]]*)]%(([^)]+)%)")
    return path
  end

  return nil
end

--- Check if a file exists
local function file_exists(path)
  return vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1
end

--- Resolve a relative path from the current file
local function resolve_path(relative_path, base_dir)
  -- Remove anchor if present
  local path = relative_path:gsub("#.*$", "")

  -- If already absolute, return as-is
  if vim.fn.fnamemodify(path, ":p") == path then
    return path
  end

  -- Resolve relative to base directory
  local resolved = vim.fn.fnamemodify(base_dir .. "/" .. path, ":p")
  return resolved
end

--- Open a file at the given path
local function open_file(path)
  if not file_exists(path) then
    vim.notify("File not found: " .. path, vim.log.levels.WARN)
    return false
  end

  -- If it's a directory, open it in the file explorer
  if vim.fn.isdirectory(path) == 1 then
    vim.cmd("edit " .. vim.fn.fnameescape(path))
  else
    vim.cmd("edit " .. vim.fn.fnameescape(path))
  end
  return true
end

--- Main function to handle go-to-definition for markdown links
function M.goto_link_definition()
  local link = get_inline_link_at_cursor()

  if not link then
    -- Not on an inline link, fall back to LSP definition
    vim.lsp.buf.definition()
    return
  end

  -- Get the current file's directory
  local current_file = vim.api.nvim_buf_get_name(0)
  local base_dir = vim.fn.fnamemodify(current_file, ":h")

  -- Resolve the path
  local resolved_path = resolve_path(link, base_dir)

  -- Try to open the file
  if open_file(resolved_path) then
    vim.notify("Opened: " .. resolved_path, vim.log.levels.INFO)
  end
end

--- Setup the keymap override for markdown files
function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function(opts)
      local bufnr = opts.buf
      -- Override gd to use our custom link navigation
      vim.keymap.set("n", "gd", M.goto_link_definition, { buffer = bufnr, noremap = true, silent = true })
    end,
  })
end

return M
