local keymaps = {
	{ "n", "<S-Right>", ":BufferLineMoveNext<CR>" },
	{ "n", "<S-Left>", ":BufferLineMovePrev<CR>" },
	{ "n", "<S-l>", ":BufferLineCycleNext<CR>" },
	{ "n", "<S-h>", ":BufferLineCyclePrev<CR>" },
	{ "n", "<leader>p", ":BufferLineTogglePin<CR>" },
	{ "n", "<leader>Q", ":BufferLineCloseOthers<CR>" },
	{ "n", "<S-t>", ":BufferLinePick<CR>" },
}

for _, map in ipairs(keymaps) do
	local opts = { noremap = true, silent = true }
	-- Merge opts with map[4], if it exists
	local final_opts = map[4] and vim.tbl_extend("force", opts, map[4]) or opts
	vim.keymap.set(map[1], map[2], map[3], final_opts)
end

return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	opts = {
		options = {
			numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
			close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
			right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
			left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
			middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
			indicator = {
				style = "none",
			},
			buffer_close_icon = "",
			themable = true,
			modified_icon = "●",
			close_icon = "",
			-- close_icon = '',
			left_trunc_marker = "",
			right_trunc_marker = "",
			max_name_length = 30,
			max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
			tab_size = 21,
			diagnostics = false, -- | "nvim_lsp" | "coc",
			diagnostics_update_in_insert = false,
			offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
			show_buffer_icons = true,
			show_buffer_close_icons = true,
			show_close_icon = true,
			show_tab_indicators = true,
			persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
			-- can also be a table containing 2 custom separators
			-- [focused and unfocused]. eg: { '|', '|' }
			separator_style = "thin",
			enforce_regular_tabs = true,
			always_show_bufferline = true,
			-- sort_by = 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
			--   -- add custom logic
			--   return buffer_a.modified > buffer_b.modified
			-- end
		},
		highlights = {
			buffer_selected = {
				--bg = "#455F87",
				--guifg = { attribute = "fg", highlight = "#ff0000" },
				--guibg = { attribute = "bg", highlight = "#0000ff" },
				--[[ gui = "none", ]]
			},
			buffer_visible = {
				guifg = { attribute = "fg", highlight = "TabLine" },
				guibg = { attribute = "bg", highlight = "TabLine" },
			},
			close_button_selected = {
				guifg = { attribute = "fg", highlight = "TabLineSel" },
				guibg = { attribute = "bg", highlight = "TabLineSel" },
			},
			separator = {
				fg = "#192334",
			},
		},
	},
}
