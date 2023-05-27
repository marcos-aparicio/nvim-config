vim.api.nvim_set_var(
  "vimwiki_list",
  { {
    path = "~/Documents/vimwiki",
    syntax = "markdown",
    ext = ".md",
    auto_generate_links = 1,
  } }
)
vim.cmd("command! Vwl lua vim.cmd('VimwikiGenerateLinks')")
