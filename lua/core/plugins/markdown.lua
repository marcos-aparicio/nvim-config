return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
    -- Only ever renders markdown buffers, so only load for those.
    ft = { "markdown", "markdown.mdx" },
    cmd = { "RenderMarkdown" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      -- Customize bullet icons
      bullet = {
        icons = { "• ", "‣ ", "∙ ", "◦ " }, -- Small and clean bullet icons
      },
    },
  },
}
