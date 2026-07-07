return {
  {
    "RedsXDD/neopywal.nvim",
    name = "neopywal",
    lazy = false,
    priority = 1000,
    config = function()
      local neopywal = require("neopywal")
      neopywal.setup()
      --  known bug (or intended behaviour) from neopywal so in order to apply even light thmes this has to be dark
      vim.cmd.colorscheme("neopywal-dark")
    end
  }
}
