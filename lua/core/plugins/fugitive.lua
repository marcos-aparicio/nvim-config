return {
  "tpope/vim-fugitive",
  keys = {
    { "<leader>ga", ":G add<space>" },
    { "<leader>go", ":G open<CR>" }, -- custom command of mine
    { "<leader>gw", ":Gwrite<CR>" },
    { "<leader>gc", ":G commit<CR>" },
    { "<leader>gu", ":G reset %<CR>" },
    { "<leader>gl", ":vertical G log -n 300<CR>" },
    { "<leader>gf", ":G fetch<space>" },
    { "<leader>gps", ":G push<space>" },
    { "<leader>gpl", ":G pull origin<space>" },
    { "<leader>gnb", ':G checkout -b ""<left>' },
    { "<leader>gr", ":G rebase -i HEAD~" },
    { "<leader>gk", ":G checkout -- %" },
    { "<leader>gw", ":diffput<CR>", mode = "v" },
    { "<leader>gh", ":0G log -n 300<CR>", ft = "git", desc = "Open git log in the current buffer" },
    -- fugitive's two non-<leader> globals: yank the current git object, and
    -- insert the git path on the command line.
    { "y<C-G>", desc = "fugitive: yank git object" },
    { "<C-R><C-G>", mode = "c", desc = "fugitive: insert git path" },
  },
  cmd = {
    "G", "Git", "Gcd", "Glcd", "Gedit", "Ge", "Gsplit", "Gvsplit", "Gtabedit", "Gpedit",
    "Gdrop", "Gread", "Gr", "Gwrite", "Gw", "Gwq", "Gdiffsplit", "Ghdiffsplit", "Gvdiffsplit",
    "GMove", "Gmove", "GRename", "Grename", "GDelete", "Gdelete", "GRemove", "Gremove",
    "GUnlink", "GBrowse", "Gbrowse", "Ggrep", "Glgrep", "Gclog", "GcLog", "Gllog", "GlLog",
  },
}
