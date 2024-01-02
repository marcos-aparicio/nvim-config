return {
	"nvim-tree/nvim-web-devicons",
	lazy = true,
	config = function()
		require("nvim-web-devicons").setup({
			override_by_extension = {
				["blade.php"] = {
					icon = "",
					color = "#f1502f",
					name = "Blade",
				},
				["toml"] = {
					icon = "T",
					color = "#ffffff",
					name = "TOML",
				},
				["vite.config.js"] = {
					icon = "",
					color = "#FFFF00",
					name = "Vite",
				},
			},
		})
	end,
}
