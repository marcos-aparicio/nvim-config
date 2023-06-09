local wiki_paths = {
	os.getenv("HOME") .. "/Obsidian/obsidian/C",
	os.getenv("HOME") .. "/Obsidian/obsidian/D",
}

local vimwiki_paths_object = {}
for _, path in pairs(wiki_paths) do
	local vimwiki_path_object = {
		path = path,
		syntax = "markdown",
		ext = ".md",
		auto_generate_links = 1,
	}
	table.insert(vimwiki_paths_object, vimwiki_path_object)
end

vim.api.nvim_set_var("vimwiki_list", vimwiki_paths_object)
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

	for _, path in pairs(wiki_paths) do
		if buffer_path:match(path) then
			vim.api.nvim_buf_set_keymap(
				buffer,
				"n",
				"<Leader>f",
				':lua require"telescope.builtin".find_files({ cwd = "'
					.. path
					.. '", prompt_title = "vimwiki", previewer = false })<CR>',
				{ noremap = true }
			)
			vim.api.nvim_buf_set_keymap(
				buffer,
				"n",
				"<Leader>l",
				":Telescope vimwiki live_grep<CR>",
				{ noremap = true }
			)
			vim.api.nvim_buf_set_keymap(
				buffer,
				"n",
				"<Leader>x",
				":w ~/.local/share/Trash/files/%:t<Bar>:VimwikiDeleteFile<CR>y<CR>",
				{ noremap = true }
			)
		end
	end
end
