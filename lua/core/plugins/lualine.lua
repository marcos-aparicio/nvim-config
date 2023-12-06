local colors = {
	color1 = nil,
	color2 = "#242b38",
	-- color2 = nil,
	color3 = "#d4bfff",
	color4 = "#d9d7ce",
	color5 = "#272d38",
	color13 = "#bbe67e",
	color10 = "#59c2ff",
	color8 = "#f07178",
	color9 = "#607080",
}

local custom_ayu_mirage = {
	visual = {
		a = { fg = colors.color2, bg = colors.color3, gui = "bold" },
		b = { fg = colors.color4, bg = colors.color5 },
	},
	replace = {
		a = { fg = colors.color2, bg = colors.color8, gui = "bold" },
		b = { fg = colors.color4, bg = colors.color5 },
	},
	inactive = {
		c = { fg = colors.color4, bg = colors.color1 },
		a = { fg = colors.color4, bg = colors.color5, gui = "bold" },
		b = { fg = colors.color4, bg = colors.color5 },
	},
	normal = {
		c = { fg = colors.color9, bg = colors.color1 },
		a = { fg = colors.color2, bg = colors.color13, gui = "bold" },
		b = { fg = colors.color4, bg = colors.color5 },
	},
	insert = {
		a = { fg = colors.color2, bg = colors.color10, gui = "bold" },
		b = { fg = colors.color4, bg = colors.color5 },
	},
}
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
	options = {
		theme = custom_ayu_mirage,
		component_separators = "|",
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = {
			{ "mode", separator = { left = "" }, right_padding = 2 },
		},
		lualine_b = { "filename", "branch" },
		lualine_c = { "fileformat" },
		lualine_x = {},
		lualine_y = { "filetype", "progress" },
		lualine_z = {
			{ "location", separator = { right = "" }, left_padding = 2 },
		},
	},
	inactive_sections = {
		lualine_a = { "filename" },
		lualine_b = { "branch" },
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "location" },
	},
	tabline = {},
	extensions = {},
}
}
