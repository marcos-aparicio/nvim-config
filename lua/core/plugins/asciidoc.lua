return {
  "tigion/nvim-asciidoc-preview",
  ft = { "asciidoc" },
  keys = {
    { "<C-p>", "<Cmd>AsciiDocPreview<CR>", ft = { "asciidoc" } },
    { ",ll", "<Cmd>AsciiDocPreview<CR>", ft = { "asciidoc" } },
  },
  build = "cd server && npm install --omit=dev",
  opts = {
    server = {
      converter = "js",
    },
    preview = {
      position = "current",
    },
  },
}
