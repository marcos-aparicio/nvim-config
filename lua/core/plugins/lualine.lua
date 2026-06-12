local function get_spell_status()
  return vim.bo.spelllang
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = 'pywal',
      component_separators = "|",
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        statusline = { "alpha" },
      },
    },
    sections = {
      lualine_a = {
        { "mode", separator = { left = "" }, right_padding = 2 },
      },
      lualine_b = { "filename", "branch" },
      lualine_c = {
        {
          "navic",

          -- Component specific options
          color_correction = nil, -- Can be nil, "static" or "dynamic". This option is useful only when you have highlights enabled.
          -- Many colorschemes don't define same backgroud for nvim-navic as their lualine statusline backgroud.
          -- Setting it to "static" will perform a adjustment once when the component is being setup. This should
          --   be enough when the lualine section isn't changing colors based on the mode.
          -- Setting it to "dynamic" will keep updating the highlights according to the current modes colors for
          --   the current section.

          navic_opts = nil, -- lua table with same format as setup's option. All options except "lsp" options take effect when set here.
        },
      },
      lualine_x = {
        {
          get_spell_status,
          cond = function()
            return vim.bo.filetype == "markdown"
          end,
          separator = { left = "", right = "" },
          padding = 1,
        },
      },
      -- lualine_x = { spelllang_component },
      lualine_y = { "filetype", "progress" },
      lualine_z = {
        { "location", separator = { right = "" }, left_padding = 2 },
      },
    },
    inactive_sections = {
      lualine_a = { "filename" },
      lualine_b = { "branch" },
      lualine_c = {},
      lualine_y = {},
      lualine_z = { "location" },
    },
    tabline = {},
    extensions = {},
  },
}
