-- mini.files config extracted from https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/plugins/mini-files.lua Thank you for sharing!
return {
  { "nvim-mini/mini.diff", opts = {} },
  { "nvim-mini/mini.ai",   opts = {} },
  {
    "nvim-mini/mini.surround",
    opts = {
      mappings = {
        add = "gsa",       -- Add surrounding in Normal and Visual modes
        delete = "gsd",    -- Delete surrounding
        find = "gsf",      -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr",   -- Replace surrounding
        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },
    },
  },
  { "nvim-mini/mini.operators", opts = {} },
  {
    "nvim-mini/mini.diff",
    version = "*",
    opts = {
      view = {
        style = "sign",
      },
    },
    lazy = false,
    keys = {
      { "<leader>gh", ":lua MiniDiff.toggle_overlay()<CR>", desc = "toggle mini.diff overlay" },
    },
  },
  {
    "nvim-mini/mini.files",
    opts = function(_, opts)
      -- I didn't like the default mappings, so I modified them
      -- Module mappings created only inside explorer.
      -- Use `''` (empty string) to not create one.
      opts.mappings = vim.tbl_deep_extend("force", opts.mappings or {}, {
        close = "q",
        -- Use this if you want to open several files
        go_in = "l",
        -- This opens the file, but quits out of mini.files (default L)
        go_in_plus = "<CR>",
        -- I swapped the following 2 (default go_out: h)
        -- go_out_plus: when you go out, it shows you only 1 item to the right
        -- go_out: shows you all the items to the right
        go_out = "H",
        go_out_plus = "h",
        -- Default <BS>
        reset = "<BS>",
        -- Default @
        reveal_cwd = ".",
        show_help = "g?",
        -- Default =
        synchronize = "s",
        trim_left = "<",
        trim_right = ">",

        -- Below I created an autocmd with the "," keymap to open the highlighted
        -- directory in a tmux pane on the right
      })

      opts.windows = vim.tbl_deep_extend("force", opts.windows or {}, {
        preview = true,
        width_focus = 30,
        width_preview = 80,
      })

      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        -- Whether to use for editing directories
        -- Disabled by default in LazyVim because neo-tree is used for that
        use_as_default_explorer = true,
        -- If set to false, files are moved to the trash directory
        -- To get this dir run :echo stdpath('data')
        -- ~/.local/share/neobean/mini.files/trash
        permanent_delete = false,
      })
      return opts
    end,

    keys = {
      {
        -- Open the directory of the file currently being edited
        -- If the file doesn't exist because you maybe switched to a new git branch
        -- open the current working directory
        "<leader>e",
        function()
          local buf_name = vim.api.nvim_buf_get_name(0)
          local dir_name = vim.fn.fnamemodify(buf_name, ":p:h")
          if vim.fn.filereadable(buf_name) == 1 then
            -- Pass the full file path to highlight the file
            require("mini.files").open(buf_name, true)
          elseif vim.fn.isdirectory(dir_name) == 1 then
            -- If the directory exists but the file doesn't, open the directory
            require("mini.files").open(dir_name, true)
          else
            -- If neither exists, fallback to the current working directory
            require("mini.files").open(vim.uv.cwd(), true)
          end
        end,
        desc = "Open mini.files (Directory of Current File or CWD if not exists)",
      },
      -- Open the current working directory
      {
        "<leader>E",
        function()
          require("mini.files").open(vim.uv.cwd(), true)
        end,
        desc = "Open mini.files (cwd)",
      },
    },
  },
}
