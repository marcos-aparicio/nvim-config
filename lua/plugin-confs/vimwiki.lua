local vimwiki_path = "~/Obsidian/obsidian/C"
local vimwiki_path2 = "~/Obsidian/obsidian/D"
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
  autocmd FileType vimwiki nnoremap <Leader>f :lua require'telescope.builtin'.find_files({ cwd = ']] .. vimwiki_path .. [[', prompt_title = 'vimwiki',previewer=false })<CR>
  autocmd FileType vimwiki nnoremap <Leader>l :Telescope vimwiki live_grep<CR>
  autocmd FileType vimwiki nnoremap <Leader>x :w ~/.local/share/Trash/files/%:t \| :VimwikiDeleteFile <CR>y<CR>
augroup END
]])
--[[ autocmd FileType vimwiki nnoremap <Leader>wd :w ~/.local/share/Trash/files/%:t<CR> ]]
--[[ autocmd FileType vimwiki nnoremap <Leader>x :w ~/.local/share/Trash/files/%:t<CR>:VimwikiDeleteFile<CR> ]]
--
