-- Focus guard: during focus mode, opening a file from a config dir asks
-- first (same rules as the zsh hook: `focus guard` decides, the dirs live in
-- ~/.config/focus/guard-dirs, a +dotfiles task in focus is never asked).
-- A 5 s pause, then: go back, park the idea in +dotfiles, or stay 20 min.

if vim.fn.executable("focus") == 0 then
  return
end

local function guard(path)
  local out = vim.system({ "focus", "guard", path }, { text = true }):wait()
  -- Only 1 means "ask"; anything else (an old focus, an error) stays quiet.
  if out.code ~= 1 then
    return nil
  end
  return vim.trim(out.stdout or "")
end

local function leave(buf)
  local listed = vim.tbl_filter(function(b)
    return vim.bo[b].buflisted
  end, vim.api.nvim_list_bufs())
  if #listed <= 1 then
    vim.cmd("qall")
  else
    vim.cmd("silent! b#")
    pcall(vim.api.nvim_buf_delete, buf, { force = true })
  end
end

local function ask(buf, path, task)
  local lines = {
    "Esto es configuración, no tu tarea.",
    "En foco: " .. task,
    "¿De verdad lo necesitas ahora, o es sobreoptimización?",
  }
  -- A float, not :echo: a multi-line echo raises "Press ENTER", which would
  -- stall the countdown and eat the answer.
  local float_buf = vim.api.nvim_create_buf(false, true)
  local width = 0
  for _, line in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(line))
  end
  local win = vim.api.nvim_open_win(float_buf, false, {
    relative = "editor",
    row = math.floor((vim.o.lines - 6) / 2),
    col = math.floor((vim.o.columns - width - 4) / 2),
    width = width + 2,
    height = 5,
    style = "minimal",
    border = "rounded",
    title = " focus ",
  })
  vim.wo[win].winhighlight = "Normal:WarningMsg"
  for i = 5, 1, -1 do
    vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, vim.list_extend({ "" }, vim.list_extend(vim.deepcopy(lines), { "respira… " .. i })))
    vim.cmd("redraw")
    vim.wait(1000)
  end
  vim.api.nvim_win_close(win, true)
  vim.api.nvim_buf_delete(float_buf, { force = true })
  -- Drop whatever was typed during the pause.
  while vim.fn.getchar(0) ~= 0 do
  end

  local choice = vim.fn.confirm(table.concat(lines, "\n"), "&Volver\n&Capturar la idea y volver\n&Seguir 20 min", 1)
  vim.cmd("redraw") -- clear the dialog, or the next message asks for ENTER
  if choice == 3 then
    vim.system({ "focus", "guard-allow", path }):wait()
    vim.notify("Vale, 20 minutos. Queda anotado.", vim.log.levels.WARN)
    return
  end
  if choice == 2 then
    local idea = vim.fn.input("Idea: ")
    if idea ~= "" then
      vim.system({ "focus", "guard-capture", path, idea }):wait()
    end
  else
    vim.system({ "focus", "guard-back", path }):wait()
  end
  leave(buf)
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  desc = "Focus guard: ask before editing config during focus mode",
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then
      return
    end
    local path = vim.api.nvim_buf_get_name(args.buf)
    if path == "" then
      return
    end
    local task = guard(path)
    if task then
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(args.buf) then
          ask(args.buf, path, task)
        end
      end)
    end
  end,
})
