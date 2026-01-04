return {
  "akinsho/toggleterm.nvim",
  version = "*",
  main = "toggleterm",
  opts = {
    autochdir = true,
    shade_terminals = false,
    highlights = {
      Normal = {
        guibg = "#0a0e14",
      },
    },
  },
  keys = {
    { "<C-;>", "<Cmd>ToggleTerm<CR>", mode = { "t", "n" } },
    {
      "<leader>lg",
      function()
        local Terminal = require("toggleterm.terminal").Terminal
        local lazygit = Terminal:new({
          cmd = "lazygit",
          direction = "float",
          close_on_exit = true,
          float_opts = {
            border = "rounded",
            width = math.floor(vim.o.columns * 0.85),
            height = math.floor(vim.o.lines * 0.85),
          },
        })
        lazygit:open()
      end,
      mode = { "n", "t" },
      desc = "Open lazygit in floating terminal",
    },
    {
      "<leader><leader>tr",
      function()
        if not _G.translate_shell_term then
          local Terminal = require("toggleterm.terminal").Terminal
          _G.translate_shell_term = Terminal:new({
            cmd = "trans -I",
            direction = "float",
            close_on_exit = true,
            float_opts = {
              border = "rounded",
              width = math.floor(vim.o.columns * 0.55),
              height = math.floor(vim.o.lines * 0.55),
            },
          })
        end
        _G.translate_shell_term:toggle()
      end,
      mode = { "n", "t" },
      desc = "Open translate-shell in floating terminal",
    },
    {
      "<leader>=",
      function()
        if not _G.qalc_term then
          local Terminal = require("toggleterm.terminal").Terminal
          _G.qalc_term = Terminal:new({
            cmd = "qalc",
            direction = "float",
            close_on_exit = true,
            float_opts = {
              border = "rounded",
              width = math.floor(vim.o.columns * 0.55),
              height = math.floor(vim.o.lines * 0.35),
            },
          })
        end
        _G.qalc_term:toggle()
      end,
      mode = { "n", "t" },
      desc = "Toggle qalc in floating terminal",
    },
    { "<leader>ld", "<Cmd>TermExec direction=float cmd=lazydocker<CR>", mode = { "t", "n" } },
    -- Custom key for lf in a floating terminal
    {
      "<leader>lf",
      function()
        local Terminal = require("toggleterm.terminal").Terminal
        local sel = vim.fn.tempname()
        local cmd
        if vim.fn.executable("yazi") == 1 then
          cmd = ("yazi --chooser-file %s"):format(sel)
        elseif vim.fn.executable("lf") == 1 then
          cmd = ("lf -selection-path %s"):format(sel)
        else
          vim.notify("Neither yazi nor lf is installed!", vim.log.levels.ERROR)
          return
        end

        local term = Terminal:new({
          cmd = cmd,
          direction = "float",
          float_opts = {
            border = "rounded",
            width = math.floor(vim.o.columns * 0.85),
            height = math.floor(vim.o.lines * 0.85),
          },
          on_exit = function(_, _, exit_code, _)
            local paths = {}
            if vim.fn.filereadable(sel) == 1 then
              paths = vim.fn.readfile(sel) -- lf writes one path per line
            end
            pcall(vim.fn.delete, sel)

            -- proceed if you actually have selection, regardless of exit_code
            if #paths == 0 then
              vim.notify("No files selected", vim.log.levels.WARN)
              return
            end

            -- your follow-up action here (yank, send to CopilotChat, etc.)
            vim.fn.setreg("+", table.concat(paths, "\n"))
            vim.notify("Selected:\n" .. table.concat(paths, "\n"))
          end,
          close_on_exit = true,
        })

        term:open()
      end,
      mode = { "n" },
      desc = "Pick file(s) via lf in floating terminal",
    },
  },
}
