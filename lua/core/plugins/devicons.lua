return {
	"nvim-tree/nvim-web-devicons",
	lazy = true,
	main = "nvim-web-devicons",
	opts = {
		override_by_extension = {
			["blade.php"] = {
				icon = "",
				color = "#f1502f",
				name = "Blade",
			},
			["adoc"] = {
				icon = "",
				color = "#ffffff",
				name = "TOML",
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
			["drawio"] = {
				icon = "󰽀",
				color = "#f1502f",
			},
		},
	},
}
