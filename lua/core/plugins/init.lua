return {
  "tpope/vim-abolish",
  {
    "kkoomen/vim-doge",
    build = ":call doge#install()",
    init = function()
      vim.g.doge_mapping = "<leader>dd" -- Change this to your desired mapping
    end,
  },
  "tpope/vim-speeddating",
  "tpope/vim-dispatch",
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
  { "lukas-reineke/virt-column.nvim", opts = {
    char ={ ".","." },
    virtcolumn = "80,100",
    highlight = {"@comment","@comment"}
  } },
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
  { "Pocco81/HighStr.nvim",  main = "high-str",       opts = {} },
  {
    "ziontee113/color-picker.nvim",
    cmd = { "PickColor", "PickColorInsert" },
    keys = {
      { "<leader>co", "<Cmd>PickColor<CR>",       mode = { "n" } },
      { "<C-c>",      "<Cmd>PickColorInsert<CR>", mode = { "i" } },
    },
    main = "color-picker",
    opts = {},
  },
  { "windwp/nvim-autopairs", main = "nvim-autopairs", opts = {} },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons", "moll/vim-bbye" },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    keys = {
      { "<C-p>", "<Cmd>MarkdownPreview<CR>", ft = { "markdown", "vimwiki" } },
      { ",ll",   "<Cmd>MarkdownPreview<CR>", ft = { "markdown", "vimwiki" } },
    },
    ft = { "markdown", "vimwiki" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      bigfile = {
        notify = true,            -- show notification when big file detected
        size = 1.5 * 1024 * 1024, -- 1.5MB
        line_length = 500,       -- average line length (useful for minified files)
        -- your bigfile configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      picker = {
        ui_select = true,
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
      { "<leader>la", ":Laravel artisan<cr>" },
      { "<leader>lr", ":Laravel routes<cr>" },
      { "<leader>lm", ":Laravel related<cr>" },
    },
    event = { "VeryLazy" },
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
    "wakatime/vim-wakatime",
    lazy = false,
    opts = {
      api_key_vault_cmd = "pass show wakatime_api_key",
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    keys = {
      { "<leader>ln", ":GrugFar<CR>" },
      { "<leader>lb", ":lua require('grug-far').open({ prefills = { paths = vim.fn.expand(\"%\") } })<CR>" },
      {
        "<leader>lb",
        function()
          require('grug-far').open({ visualSelectionUsage = 'operate-within-range' })
        end,
        mode = { "v" },
        desc = 'grug-far: Search within range'
      }
    },
    config = function()
      require("grug-far").setup()
    end,
  },
  {
    "mistweaverco/kulala.nvim",
    keys = {
      { "<leader>ps", desc = "Send request" },
      { "<leader>pa", desc = "Send all requests" },
      { "<leader>pb", desc = "Open scratchpad" },
    },
    ft = {"http", "rest"},
    opts = {
      global_keymaps = true,

      global_keymaps_prefix = "<leader>p",
      kulala_keymaps_prefix = "",
    },
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
