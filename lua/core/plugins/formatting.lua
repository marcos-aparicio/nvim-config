return {
	{
		"stevearc/conform.nvim",
		config = function()
			local conform = require("conform")

			local formatting_activated = true

			function ToggleFormatting()
				formatting_activated = not formatting_activated
				if formatting_activated then
					print("Auto Formatting enabled")
					return
				end
				print("Auto Formatting disabled")
			end
			vim.cmd([[command! ToggleFormatting lua ToggleFormatting()]])

			conform.setup({
				formatters_by_ft = {
					python = { { "isort", "black" } },
					javascript = { "prettier", "prettierd" },
					typescript = { "prettierd" },
					javascriptreact = { "prettierd" },
					blade = { "prettierd", "blade-formatter", "prettier" },
					typescriptreact = { "prettierd" },
					svelte = { "prettierd" },
					css = { "prettierd" },
					html = { "prettierd" },
					json = { "prettierd" },
					yaml = { "prettierd" },
					-- markdown = { "prettierd" },
					graphql = { "prettierd" },
					lua = { "stylua" },
					php = { "pretty-php" },
				},
				format_on_save = function()
					return {
						lsp_fallback = true,
						async = false,
						timeout_ms = 1000,
						dry_run = not formatting_activated,
					}
				end,
			})

			vim.keymap.set({ "n", "v" }, "<leader>mp", function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				})
				print("formatting applied")
			end, { desc = "Format file or range (in visual mode)" })
		end,
	},
	{
		"laytan/tailwind-sorter.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
		build = "cd formatter && npm i && npm run build",
		config = function()
			require("tailwind-sorter").setup({
				on_save_enabled = true, -- If `true`, automatically enables on save sorting.
				on_save_pattern = {
					"*.html",
					"*.js",
					"*.jsx",
					"*.tsx",
					"*.twig",
					"*.hbs",
					"*.php",
					"*.heex",
					"*.astro",
				}, -- The file patterns to watch and sort.
				node_path = "node",
			})
		end,
	},
}
