return {
  -- plenary is only ever pulled in as a dependency now, so its test-runner
  -- commands need declaring to stay reachable.
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
    cmd = { "PlenaryBustedFile", "PlenaryBustedDirectory" },
  },
  -- Abolish installs the `cr` coercion operator and :S/:Subvert. Loading it at
  -- VeryLazy keeps the mappings identical without paying for it during startup.
  { "tpope/vim-abolish", event = "VeryLazy" },
  {
    "kkoomen/vim-doge",
    build = ":call doge#install()",
    cmd = { "DogeGenerate" },
    keys = { { "<leader>dd", desc = "DOGE: generate docblock" } },
    init = function()
      vim.g.doge_mapping = "<leader>dd" -- Change this to your desired mapping
    end,
  },
  -- <C-a>/<C-x> are what speeddating overrides; VeryLazy preserves the current
  -- mapping precedence (codecompanion's <C-a> stub is registered before this).
  { "tpope/vim-speeddating", event = "VeryLazy" },
  {
    "tpope/vim-dispatch",
    cmd = { "Dispatch", "Start", "Spawn", "Make", "Focus", "FocusDispatch", "AbortDispatch", "Copen" },
    -- dispatch's 20 default mappings, declared so they keep working without
    -- the plugin being present: m* = :Make, `* = :Dispatch, '* = :Start,
    -- g'*/g`* = :Spawn.
    keys = (function()
      local keys = {}
      for _, prefix in ipairs({ "m", "`", "'", "g`", "g'" }) do
        for _, suffix in ipairs({ "<Space>", "<CR>", "!", "?" }) do
          keys[#keys + 1] = prefix .. suffix
        end
      end
      return keys
    end)(),
  },
  -- "Treesitter for rasi filetype"
  { "Fymyte/rasi.vim",          ft = "rasi" },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<C-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<C-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<C-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<C-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  { "andrewradev/linediff.vim", cmd = "Linediff" },
  {
    "lukas-reineke/virt-column.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      char = { ".", "." },
      virtcolumn = "80,100",
      highlight = { "@comment", "@comment" },
    },
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    main = "colorizer",
    opts = {},
  },
  -- {
  --   "lewis6991/gitsigns.nvim",
  --   event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  --   opts = {},
  -- },
  {
    "Pocco81/HighStr.nvim",
    cmd = { "HSHighlight", "HSRmHighlight", "HSExport", "HSImport" },
    main = "high-str",
    opts = {},
  },
  {
    "ziontee113/color-picker.nvim",
    cmd = { "PickColor", "PickColorInsert" },
    keys = {
      {
        "<leader><leader>co",
        "<Cmd>PickColor<CR>",
        mode = { "n" },
        desc = "Open color picker",
      },
      { "<C-c>", "<Cmd>PickColorInsert<CR>", mode = { "i" } },
    },
    main = "color-picker",
    opts = {},
  },
  { "windwp/nvim-autopairs", event = "InsertEnter", main = "nvim-autopairs", opts = {} },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons", "moll/vim-bbye" },
  },
  {
    "selimacerbas/markdown-preview.nvim",
    dependencies = { "selimacerbas/live-server.nvim" },
    cmd = { "MarkdownPreview", "MarkdownPreviewRefresh", "MarkdownPreviewStop" },
    main = "markdown_preview",
    opts = {
      instance_mode = "takeover", -- "takeover" (one tab) or "multi" (tab per instance)
      port = 0,                   -- 0 = auto (8421 for takeover, OS-assigned for multi)
      open_browser = true,
      default_theme = "dark",     -- "dark" or "light"; initial preview theme
      debounce_ms = 300,
    }
  },
  {
    "selimacerbas/live-server.nvim",
    cmd = {
      "LiveServerStart",
      "LiveServerOpen",
      "LiveServerReload",
      "LiveServerToggleLive",
      "LiveServerStop",
      "LiveServerStatus",
      "LiveServerStopAll",
    },
  },
  {
    "folke/snacks.nvim",
    lazy = false,
    keys = {
      {
        "<leader>av",
        function()
          Snacks.picker.lsp_symbols({ filter = { default = { "Variable", "Constant", "Field", "Property", "Object" }, lua = { "Variable", "Constant", "Field", "Property", "Object" } } })
        end,
        desc = "Toggle LSP Symbols Snack picker with only variables"
      },
      {
        "<leader>af",
        function()
          Snacks.picker.lsp_symbols({ filter = { default = { "Function", "Method" }, lua = { "Function", "Method" } } })
        end,
        desc = "Toggle LSP Symbols Snack picker with only functions"
      }
    },
    ---@type snacks.Config
    opts = {
      bigfile = {
        notify = true,            -- show notification when big file detected
        size = 1.5 * 1024 * 1024, -- 1.5MB
        line_length = 500,        -- average line length (useful for minified files)
        -- your bigfile configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      picker = {
        ui_select = true,
        lsp_symbols = {
          -- Show ALL symbol types (default filter hides Variable, Constant, etc.)
          filter = {
            default = true, -- true = show all symbols
            lua = nil,
          },
        },
        actions = {
          yank_clipboard = { action = "yank", reg = "+", field = "name" },
        },
        win = {
          input = {
            keys = {
              ["yy"] = { "yank_clipboard", mode = { "n", "i" }, desc = "Yank to clipboard" },
            },
          },
        },

      },
      styles = {
        snacks_image = {
          relative = "editor",
          col = -1,
        },
      },
      image = {
        enabled = function(bufnr)
          local ft = vim.bo[bufnr].filetype
          -- disable for HTML
          if ft == "html" then
            return false
          end
          return true
        end,
        doc = {
          -- only used if `opts.inline` is disabled
          float = true,
          -- Sets the size of the image
          max_width = 60,
          max_height = 30,
          -- max_width = 60,
          -- max_height = 30,
          -- Apparently, all the images that you preview in neovim are converted
          -- to .png and they're cached, original image remains the same, but
          -- the preview you see is a png converted version of that image
          --
          -- Where are the cached images stored?
          -- This path is found in the docs
          -- :lua print(vim.fn.stdpath("cache") .. "/snacks/image")
          -- For me returns `~/.cache/neobean/snacks/image`
          -- Go 1 dir above and check `sudo du -sh ./* | sort -hr | head -n 5`
        },
      },
    },
  },
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "tpope/vim-dotenv",
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
      "kevinhwang91/promise-async",
    },
    cmd = { "Laravel" },
    keys = {
      { "<leader>lla", ":Laravel artisan<cr>", ft = "php" },
      { "<leader>llr", ":Laravel routes<cr>", ft = "php" },
      { "<leader>llm", ":Laravel related<cr>", ft = "php" },
    },
    opts = {},
    config = true,
  },
  {
    "chrisgrieser/nvim-rip-substitute",
    keys = {
      {
        "<leader>rs",
        function()
          require("rip-substitute").sub()
        end,
        mode = { "n", "x" },
        desc = " rip substitute",
      },
    },
  },
  {
    -- plugin/wakatime.vim alone costs ~60ms of startup (python/cli discovery).
    -- Deferring to VeryLazy keeps tracking intact but off the critical path.
    "wakatime/vim-wakatime",
    event = "VeryLazy",
    opts = {
      api_key_vault_cmd = "pass show wakatime_api_key",
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    keys = {
      { "<leader>ln", ":GrugFar<CR>" },
      {
        "<leader>lb",
        ":lua require('grug-far').open({ prefills = { paths = vim.fn.expand(\"%\") } })<CR>",
      },
      {
        "<leader>lb",
        function()
          require("grug-far").open({ visualSelectionUsage = "operate-within-range" })
        end,
        mode = { "v" },
        desc = "grug-far: Search within range",
      },
    },
    config = function()
      require("grug-far").setup()
    end,
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      -- add options here
      -- or leave it empty to use the default settings
    },
    keys = {
      -- suggested keymap
      { "<leader>ip", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
  },
}
