return {
  "L3MON4D3/LuaSnip",
  dependencies = { "hrsh7th/nvim-cmp", "rafamadriz/friendly-snippets", "saadparwaiz1/cmp_luasnip" },
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  opts = function()
    local languages = {
      "markdown",
      "javascript",
      "html",
      "ledger",
      "sql",
      "octo",
      "python",
      "markdown",
      "php",
    }
    require("luasnip.loaders.from_vscode").lazy_load()
    for _, language in pairs(languages) do
      pcall(require, "core.plugins.snippets.settings." .. language)
    end
    return {}
  end,
}
