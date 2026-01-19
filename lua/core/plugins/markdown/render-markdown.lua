local list_patterns = {
  unordered = "[-+*]", -- - + *
  digit = "%d+[.)]", -- 1. 2. 3.
  ascii = "%a[.)]", -- a) b) c)
  roman = "%u*[.)]", -- I. II. III.
  latex_item = "\\item",
}

return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
  tag = "v8.10.0",
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    -- Customize bullet icons
    bullet = {
      enabled = false,
      icons = { "• ", "‣ ", "∙ ", "◦ " }, -- Small and clean bullet icons
    },
    heading = {
      sign = true,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      custom = {
        todo_pattern = {
          pattern = "^## To Do$",
          icon = "󰲣    ",
        },
        notes_pattern = {
          pattern = "^## Notes$",
          icon = "󰲣  📝 ",
        },
      },
    },
    document = {
      enabled = true,
      render_modes = false,
      conceal = {
        char_patterns = {
          "=%s*date%(.-%) %- date%(%d%d%d%d%-%d%d%-%d%d%)",
        },
      },
    },
    checkbox = {
      custom = {
        todo = {
          raw = "[-]",
          rendered = "󰥔 ",
          highlight = "RenderMarkdownTodo",
          scope_highlight = nil,
        },
        not_gonna_do = {
          raw = "[c]",
          rendered = "󰅖 ", -- choose an appropriate icon
          highlight = "RenderMarkdownTodoCancelled",
          scope_highlight = nil,
        },
        waiting = {
          raw = "[w]",
          rendered = "⏳",
          highlight = "RenderMarkdownTodoCancelled",
          scope_highlight = nil,
        },
        incubating = {
          raw = "[0]",
          rendered = "🥚",
          highlight = "RenderMarkdownTodoCancelled",
          scope_highlight = nil,
        }
      },
    },
  },
  init = function()
    require("core.plugins.markdown.autocmds").setup()
  end,
  config = true,
}
