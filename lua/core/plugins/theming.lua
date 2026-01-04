return {
  "Shatur/neovim-ayu",
  priority = 1000,
  event = "VeryLazy",
  main = "ayu",
  opts = function()
    local overrides = {
      Normal = { bg = "None" },
      NormalFloat = { bg = "none" },
      Winbar = { bg = "none" },
      ColorColumn = { bg = "None" },
      TabLineFill = { bg = "None" },
      SignColumn = { bg = "None" },
      Folded = { bg = "None" },
      FoldColumn = { bg = "None" },
      CursorLine = { bg = "None" },
      CursorColumn = { bg = "None" },
      VertSplit = { bg = "None" },
      LineNr = { fg = "#FFD580" },
      RenderMarkdownTodoCancelled = { fg = "#e06c75" },
      RenderMarkdownTodoCurrent = { fg = "#FFAA33" },
      TelescopePromptCounter = { fg = "#FFD580", bg = "None" },
      LineNrAbove = { fg = "#606366" },
      LineNrBelow = { fg = "#606366" },
      TelescopeSelection = { bg = "#444444", bold = true },
      TelescopePreviewLine = { bg = "#444444", bold = true },
    }

    -- Programmatically insert custom highlight groups
    local custom_highlights = {
      BlinkCmpMenu = { bg = "#1e1e2e", fg = "#cdd6f4" },
      BlinkCmpMenuBorder = { bg = "#1e1e2e", fg = "#89b4fa" },
      BlinkCmpMenuSelection = { bg = "#313244", fg = "#cdd6f4" },
      BlinkCmpKind = { fg = "#cdd6f4", bg = "#1e1e2e" },
      BlinkCmpKindText = { fg = "#8b97aa", bg = "#1e1e2e" },
      RenderMarkdownBullet = { fg = "#FCFCFC", bold = true },
      RenderMarkdownCode = { bg = "#181922" },
      Underlined = { fg = "#3399ff", underline = true, bold = true },
    }

    -- Heading highlight definitions
    local heading_defs = {
      { fg = "#ff4444", bg = "#331111" }, -- H1
      { fg = "#ffaa33", bg = "#332211" }, -- H2
      { fg = "#ffe066", bg = "#333311" }, -- H3
      { fg = "#44dd77", bg = "#113322" }, -- H4
      { fg = "#33bbff", bg = "#112233" }, -- H5
      { fg = "#bb66ff", bg = "#221133" }, -- H6
    }
    for i, def in ipairs(heading_defs) do
      custom_highlights["RenderMarkdownH" .. i] = vim.tbl_extend("force", { bold = true }, def)
      custom_highlights["RenderMarkdownH" .. i .. "Bg"] =
        vim.tbl_extend("force", { bold = true }, def)
    end

    for k, v in pairs(custom_highlights) do
      overrides[k] = v
    end

    return {
      mirage = false,
      overrides = overrides,
    }
  end,
  init = function()
    vim.opt.syntax = "on"
    vim.o.termguicolors = true
    vim.g.Powerline_symbols = "fancy"
    vim.g.ayucolor = "dark"
    vim.cmd([[ colorscheme default ]])
    require("ayu").colorscheme()
  end,
}
