return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  -- mini.files owns `use_as_default_explorer`, so neo-tree never has to be
  -- present at startup: <C-n> and :Neotree are the only ways in.
  cmd = "Neotree",
  keys = { { "<C-n>", ":Neotree toggle<CR>", desc = "Toggle Neotree" } },
  ---@module "neo-tree"
  ---@type neotree.Config?
  opts = {
    -- fill any relevant options here
  },
}
