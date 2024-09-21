return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	"HiPhish/rainbow-delimiters.nvim",
	"nvim-treesitter/nvim-treesitter-context",
	"EmranMR/tree-sitter-blade",
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "lua" },
				sync_install = false,
				ignore_install = { "latex" }, --languages you dont want the maintained version
				autotag = { enable = true },
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
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							-- You can optionally set descriptions to the mappings (used in the desc parameter of
							-- nvim_buf_set_keymap) which plugins like which-key display
							["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
							-- You can also use captures from other query groups like `locals.scm`
							["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["av"] = "@assignment.outer",
							["iv"] = "@assignment.inner",
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
					swap = {
						enable = true,
						swap_next = {
							["<leader>a"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>A"] = "@parameter.inner",
						},
					},
				},
			})
			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			parser_config.blade = {
				install_info = {
					url = "https://github.com/EmranMR/tree-sitter-blade",
					files = { "src/parser.c" },
					branch = "main",
				},
				filetype = "blade",
			}

			vim.cmd([[
			     augroup BladeFiletypeRelated
			       autocmd BufNewFile,BufRead *.blade.php set ft=php
			     augroup END
			   ]])
			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

			vim.keymap.set({ "n", "x", "o" }, "<leader>tc", ":TSContextToggle<CR>")
			-- Repeat movement with ; and ,
			-- ensure ; goes forward and , goes backward regardless of the last direction
			-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

			-- vim way: ; goes to the direction you were moving.
			-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
			-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

			-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
			-- vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
			-- vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
			-- vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
			-- vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
		end,
	},
}
