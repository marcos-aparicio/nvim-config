HOME = os.getenv("HOME")

vim.cmd([[
	augroup StripTrailingWhiteSpace
		au!
		au BufWritePre * %s/\s\+$//e
	augroup END

  augroup FormattingLedgerFiles
    autocmd BufWritePost /home/marcos/Finances/*.journal
    \ let keyword = system('grep "include.*journal" '.expand('%:p')) |
    \ if &filetype == 'ledger' && keyword != '' |
    \     echo "Not formatting since it is a index file, or includes include" |
    \ else |
    \     execute '!sh /home/marcos/.local/privbin/reorder-journal.sh ' . expand('%:p') |
    \ endif
  augroup END
  augroup TerminalMode
    autocmd!
    autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif
  augroup END
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
  augroup transparent_signs
    au!
    autocmd ColorScheme * highlight SignColumn guibg=NONE
  augroup END

  augroup HurlExtension
    autocmd BufNewFile,BufRead *.hurl setfiletype hurl
  augroup END
  augroup SqlExtension
   autocmd FileType mysql setlocal completefunc=complete_sql
   autocmd FileType mysql setlocal omnifunc=omni_sql
   autocmd FileType mysql setfiletype sql
  augroup END
  augroup TodotxtExtension
    autocmd BufNewFile,BufRead todo.txt setfiletype todotxt
  augroup END
]])

vim.g.mapleader = " "
vim.g.pyton3_host_prog = "/usr/bin/python3"
vim.g.markdown_folding = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.hlsearch = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.bo.softtabstop = 2

vim.o.clipboard = "unnamed,unnamedplus"
vim.o.hidden = true
vim.o.signcolumn = "yes"
vim.o.splitright = true

-- folding configs
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.autoread = true

-- settings required for vimwiki to work
vim.o.compatible = false
vim.cmd("filetype plugin on")
vim.cmd("syntax on")

-- Set key mappings for F15 and F16 to emulate Ctrl-Tab and Ctrl-Shift-Tab
vim.api.nvim_set_keymap("n", "<F15>", "<C-Tab>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<F16>", "<C-S-Tab>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("i", "<F15>", "<C-Tab>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("i", "<F16>", "<C-S-Tab>", { silent = true, noremap = true })

-- Set the codes for F15 and F16 to be interpreted as keystrokes
vim.api.nvim_set_var("terminal_ansi_codes", { ["F15"] = "\27[1;5I", ["F16"] = "\27[1;6I" })

vim.g.loaded_netwr = 1
vim.g.loaded_netrwPlugin = 1
