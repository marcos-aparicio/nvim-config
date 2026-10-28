-- Show the tmux window that runs an agent (omp/pi/claude) in this tmux session
-- inside a Neovim split. It is a second live view of the same process, made by
-- attaching a grouped tmux session that only shows that window and is destroyed
-- when the split's terminal closes. Both views share one size; tmux resizes the
-- window to whichever view was used last.
local agents = { omp = true, pi = true, claude = true }

local function open_agent_window()
  local pane = vim.env.TMUX_PANE
  if not pane then
    return vim.notify("Not running inside tmux", vim.log.levels.WARN)
  end
  -- Talk to the tmux server Neovim lives in, even with TMUX unset below.
  local tmux = { "tmux", "-S", vim.env.TMUX:match("^[^,]+") }
  local function cmd(...) return vim.list_extend(vim.deepcopy(tmux), { ... }) end

  local session = vim.fn.system(cmd("display-message", "-p", "-t", pane, "#S")):gsub("%s+$", "")
  local window
  for _, line in ipairs(vim.fn.systemlist(cmd("list-panes", "-s", "-t", session, "-F", "#{window_id} #{pane_current_command}"))) do
    local id, name = line:match("^(%S+) (%S+)$")
    if id and agents[name] then
      window = id
      break
    end
  end
  if not window then
    return vim.notify("No omp/pi/claude window in tmux session " .. session, vim.log.levels.WARN)
  end

  vim.cmd("botright vsplit | enew")
  local buf = vim.api.nvim_get_current_buf()
  -- `env -u TMUX`: tmux refuses to attach from inside one of its own panes.
  vim.fn.jobstart(vim.list_extend({ "env", "-u", "TMUX" }, cmd(
    "new-session", "-t", session,
    ";", "set-option", "destroy-unattached", "on",
    ";", "set-option", "status", "off",
    ";", "select-window", "-t", window
  )), {
    term = true,
    on_exit = function()
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
      end)
    end,
  })
  vim.cmd.startinsert()
end

-- Toggle the sidekick-owned session of a tool. Plain `toggle({ name = ... })`
-- also offers omp already running in another tmux window, which sidekick can
-- only send to, not show (that is what <leader>ao is for), so it would prompt
-- every time.
local function toggle_embedded(name)
  local State = require("sidekick.cli.state")
  for _, state in ipairs(State.get({ name = name })) do
    if not state.external then
      if state.session then
        return require("sidekick.cli").toggle({ filter = { session = state.session.id }, focus = true })
      end
      return State.attach(state, { show = true, focus = true })
    end
  end
end

return {
  {
    "folke/sidekick.nvim",
    opts = {
      -- Next Edit Suggestions need the Copilot LSP; only the CLI side is used.
      nes = { enabled = false },
      cli = {
        win = {
          layout = "right",
          split = { width = 0 }, -- 0 = half the screen
        },
        -- Agents run inside their own tmux session, so they survive Neovim
        -- restarts and can be attached from another pane with `tmux attach -t`.
        -- Agents already running in this project's tmux windows are detected
        -- too, and the send keymaps below can target them.
        mux = { backend = "tmux", enabled = true },
        tools = {
          omp = { cmd = { "omp" }, is_proc = "\\<omp\\>" },
          omp_resume = { cmd = { "omp", "--resume" } },
        },
      },
    },

    keys = {
      {
        "<leader>ac",
        function() toggle_embedded("omp") end,
        mode = { "n", "v" },
        desc = "Toggle omp",
      },
      {
        "<leader>an",
        function() require("sidekick.cli").select() end,
        desc = "Pick or start an agent session",
      },
      {
        "<leader>ar",
        function() toggle_embedded("omp_resume") end,
        desc = "Resume an omp session",
      },
      {
        "<leader>ao",
        open_agent_window,
        desc = "Show this tmux session's agent window in a split",
      },
      {
        "<leader>aC",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = "x",
        desc = "Send selection to agent",
      },
      {
        "<leader>aC",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        mode = "n",
        desc = "Send file to agent",
      },
      -- capitalized to avoid the buffer-local <leader>ad Anki mapping in telescope.lua
      {
        "<leader>aD",
        function() require("sidekick.cli").send({ prompt = "diagnostics" }) end,
        mode = "n",
        desc = "Send buffer diagnostics to agent",
      },
      {
        "<C-a>",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick prompt palette",
      },
    },
  },
}
