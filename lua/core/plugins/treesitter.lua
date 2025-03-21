return {
	{ "HiPhish/rainbow-delimiters.nvim", event = { "BufReadPost", "BufWritePost", "BufNewFile" } },
	{ "nvim-treesitter/nvim-treesitter-textobjects", event = { "BufReadPost", "BufWritePost", "BufNewFile" } },
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = { enable = false },
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = "VeryLazy",
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
		main = "nvim-treesitter.configs",
		opts = function()
			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			parser_config.blade = {
				install_info = {
					url = "https://github.com/EmranMR/tree-sitter-blade",
					files = { "src/parser.c" },
					branch = "main",
				},
				filetype = "blade",
			}

			vim.filetype.add({
				name = "blade",
				extensions = { "blade.php" },
				patterns = { "*.blade.php" },
			})

			vim.cmd("hi @function.blade guifg=#ff61e3")

			vim.keymap.set({ "n", "x", "o" }, "<leader>tc", ":TSContextToggle<CR>")
			return {
				ensure_installed = { "lua" },
				auto_install = true,
				sync_install = false,
				ignore_install = { "latex" }, --languages you dont want the maintained version
				autotag = { enable = true },
				modules = {},

				highlight = {
					enable = true,
					disable = { "typescriptreact" }, --don't highlight this languages
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = false, disable = { "yaml" } },
				textobjects = {
					select = {
						enable = true,

						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,

						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["aF"] = "@function.outer",
							["iF"] = "@function.inner",
							["ac"] = "@class.outer",
							-- You can optionally set descriptions to the mappings (used in the desc parameter of
							-- nvim_buf_set_keymap) which plugins like which-key display
							-- ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
							-- You can also use captures from other query groups like `locals.scm`
							-- ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
							-- ["aa"] = "@parameter.outer",
							-- ["ia"] = "@parameter.inner",
							-- ["av"] = "@assignment.outer",
							-- ["iv"] = "@assignment.inner",
						},
						-- You can choose the select mode (default is charwise 'v')
						--
						-- Can also be a function which gets passed a table with the keys
						-- * query_string: eg '@function.inner'
						-- * method: eg 'v' or 'o'
						-- and should return the mode ('v', 'V', or '<c-v>') or a table
						-- mapping query_strings to modes.
						selection_modes = {
							["@parameter.outer"] = "v", -- charwise
							["@function.outer"] = "V", -- linewise
							["@class.outer"] = "<c-v>", -- blockwise
						},
						-- If you set this to `true` (default is `false`) then any textobject is
						-- extended to include preceding or succeeding whitespace. Succeeding
						-- whitespace has priority in order to act similarly to eg the built-in
						-- `ap`.
						--
						-- Can also be a function which gets passed a table with the keys
						-- * query_string: eg '@function.inner'
						-- * selection_mode: eg 'v'
						-- and should return true of false
						include_surrounding_whitespace = false,
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
							["]r"] = "@return.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
							["]R"] = "@return.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[["] = "@class.outer",
						},
					},
					-- swap = {
					-- 	enable = true,
					-- 	swap_next = {
					-- 		["<leader>a"] = "@parameter.inner",
					-- 	},
					-- 	swap_previous = {
					-- 		["<leader>A"] = "@parameter.inner",
					-- 	},
					-- },
				},
			}
		end,
	},
}
