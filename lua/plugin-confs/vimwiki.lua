vim.api.nvim_set_var("vimwiki_list", { { path = "~/Documents/vimwiki", syntax = "markdown", ext = ".md" } })
vim.cmd("command! Vwl lua vim.cmd('VimwikiGenerateLinks')")
