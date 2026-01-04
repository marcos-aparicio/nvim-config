local width = math.floor(vim.o.columns * 0.4)
local height = vim.o.lines - 2 -- Adjust for status lines
local win_opts = {
  relative = "win",
  width = width,
  height = height,
  win = -1,
  col = vim.o.columns - width,
  row = 0,
  style = "minimal",
  border = "single",
}

local state = {
  output = {
    buf = -1,
    win = -1,
  },
}

local show_error = true

local function determineCommandForBuffer()
  local filetype = vim.o.filetype
  local current_file = vim.fn.expand("%:p")
  -- local curr_dir = vim.fn.expand("%:p:h")
  local redirect = show_error and "" or " 2>/dev/null"
  local usual_running = function(command)
    return command .. redirect .. " " .. current_file
  end

  local filetype_command = {
    ["java"] = "java",
    ["python"] = "python",
    ["sh"] = "sh",
    ["lua"] = "lua",
    ["hurl"] = "hurl --verbose",
    ["plt"] = "plot",
  }

  local command = filetype_command[filetype] or ""
  if command ~= "" then
    return usual_running(command)
  end

  if filetype == "javascript" then
    if string.match(current_file, ".*test.js$") then
      return "npm run test %"
    end
    return usual_running("node")
  elseif filetype == "php" then
    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

    if git_root and git_root ~= "" then
      current_file =
        vim.fn.systemlist("realpath --relative-to=" .. git_root .. " " .. current_file)[1]
    end
    if string.match(current_file, ".*tests/Browser/.*%.php$") then
      return "./vendor/bin/sail dusk " .. current_file
    end
    return "./vendor/bin/sail test " .. current_file
  end
  vim.notify("Not supported filetype", vim.log.levels.ERROR)
end

local function createRunnerBuffer(opts)
  local opts = opts or {}
  if opts.command == nil then
    vim.notify("You must first pass a valid command", vim.log.levels.ERROR)
    return
  end
  local buf = nil

  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
    vim.api.nvim_set_option_value("filetype", "command_runner", { buf = buf })
  end

  -- Run a shell command and capture its output
  local output = vim.fn.systemlist(opts.command)
  -- Write the command output to the buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
  local win = vim.api.nvim_open_win(buf, true, win_opts)
  SetupRunnerWindow(win, buf)
  return { buf = buf, win = win }
end

function SetupRunnerWindow(win, buf)
  vim.api.nvim_set_option_value("number", true, { win = win })
end

local function toggleRunnerBuffer()
  if vim.api.nvim_win_is_valid(state.output.win) then
    vim.api.nvim_win_hide(state.output.win)
    return
  end

  local win = vim.api.nvim_open_win(state.output.buf, true, win_opts)
  state.output.win = win
  SetupRunnerWindow(state.output.win, state.output.buf)
end

vim.api.nvim_create_user_command("ExecuteCurrentBuffer", function()
  local command = determineCommandForBuffer()
  if command == nil then
    vim.notify("There is not a valid command for that filetype", vim.log.levels.ERROR)
    return
  end

  local result =
    createRunnerBuffer({ buf = state.output.buf, win = state.output.win, command = command })
  state.output = result
end, { desc = "Execute the current buffer into a runner buffer" })

vim.api.nvim_create_user_command("ToggleRunnerBuffer", toggleRunnerBuffer, {
  desc = "Toggles the Runner Buffer",
})

vim.keymap.set("n", "<leader>rr", ":ExecuteCurrentBuffer<CR>")
vim.keymap.set("n", "<leader>rt", ":ToggleRunnerBuffer<CR>")
