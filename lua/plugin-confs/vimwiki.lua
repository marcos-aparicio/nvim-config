local wikis = require("plugin-confs.vimwiki-private")

local vimwiki_paths_object = {}
for _, wiki in ipairs(wikis) do
	local vimwiki_path_object = {
		path = wiki.path,
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

-- setting general keybinding to iterate through vimwikis

function set_vimwiki_mappings()
	local buffer = vim.api.nvim_get_current_buf()
	local buffer_path = vim.api.nvim_buf_get_name(buffer)

	for _, wiki in ipairs(wikis) do
		if buffer_path:match(wiki.path) then
			vim.api.nvim_buf_set_keymap(
				buffer,
				"n",
				"<Leader>f",
				':lua require"telescope.builtin".find_files({ cwd = "'
					.. wiki.path
					.. '", prompt_title = "vimwiki", previewer = false })<cr>',
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

function get_vimwiki_wikis()
	-- Execute Vimscript to obtain the list of Vimwiki wikis
	local wiki_list = vim.api.nvim_exec([[echo globpath(g:vimwiki_list, '**')]], true)

	-- Split the output into individual paths
	local wikis = vim.split(wiki_list, "\n", true)

	-- Remove empty paths
	for i = #wikis, 1, -1 do
		if wikis[i] == "" then
			table.remove(wikis, i)
		end
	end

	return wikis
end
