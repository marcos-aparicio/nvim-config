local vimwiki_path = os.getenv("HOME") .. "/Obsidian/obsidian/C"
local vimwiki_path2 = os.getenv("HOME") .. "/Obsidian/obsidian/D"
vim.api.nvim_set_var("vimwiki_list", {
	{
		path = vimwiki_path,
		syntax = "markdown",
		ext = ".md",
		auto_generate_links = 1,
	},
	{
		path = vimwiki_path2,
		syntax = "markdown",
		ext = ".md",
		auto_generate_links = 1,
	},
})
vim.g.wiki_auto_header = 1

vim.cmd([[
  augroup vimwiki_mappings
    autocmd!
    autocmd FileType vimwiki lua set_vimwiki_mappings()
  augroup END
]])

function set_vimwiki_mappings()
	local buffer = vim.api.nvim_get_current_buf()
	local buffer_path = vim.api.nvim_buf_get_name(buffer)
	print(buffer_path)

	if buffer_path:match(vimwiki_path) then
		vim.api.nvim_buf_set_keymap(
			buffer,
			"n",
			"<Leader>f",
			':lua require"telescope.builtin".find_files({ cwd = "'
				.. vimwiki_path
				.. '", prompt_title = "vimwiki", previewer = false })<CR>',
			{ noremap = true }
		)
		vim.api.nvim_buf_set_keymap(buffer, "n", "<Leader>l", ":Telescope vimwiki live_grep<CR>", { noremap = true })
		vim.api.nvim_buf_set_keymap(
			buffer,
			"n",
			"<Leader>x",
			":w ~/.local/share/Trash/files/%:t<Bar>:VimwikiDeleteFile<CR>y<CR>",
			{ noremap = true }
		)
	end
end

--[[ function clear_vimwiki_mappings() ]]
--[[ 	local buffer = vim.api.nvim_get_current_buf() ]]
--[[]]
--[[ 	vim.api.nvim_buf_del_keymap(buffer, "n", "<Leader>f") ]]
--[[ 	vim.api.nvim_buf_del_keymap(buffer, "n", "<Leader>l") ]]
--[[ 	vim.api.nvim_buf_del_keymap(buffer, "n", "<Leader>x") ]]
--[[ end ]]
