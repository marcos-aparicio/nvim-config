local function setup()
	require("formatter").setup({
		filetype = {
			lua = { require("formatter.filetypes.lua").stylua },
		},
	})
end

return setup
