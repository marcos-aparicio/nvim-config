-- mapping functions based on: https://github.com/arnvald/viml-to-lua/blob/main/lua/mappings.lua (checkout his repo is very informative)
function nmap(shortcut, command)
	map("n", shortcut, command)
end

function imap(shortcut, command)
	map("i", shortcut, command)
end

function vmap(shortcut, command)
	map("v", shortcut, command)
end

function cmap(shortcut, command)
	map("c", shortcut, command)
end

function tmap(shortcut, command)
	map("t", shortcut, command)
end

function map(mode, shortcut, command)
	vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

local M = {}
M.nmap = nmap
M.imap = imap
M.vmap = vmap
M.cmap = cmap
M.tmap = tmap

function ExitBuffer()
	if vim.bo.filetype == "TelescopePrompt" then
		vim.cmd("quit!")
		return
	end
	local win_amount = #vim.api.nvim_tabpage_list_wins(0)

	local ok, tree = pcall(require, "nvim-tree.view")
	local tree_opened = ok and tree.is_visible() or false

	if win_amount <= 1 or win_amount == 2 and tree_opened then
		vim.cmd("Bdelete")
		return
	end
	vim.cmd("quit")
end

-- markdown keybinding(s)
vim.cmd([[
augroup MarkdownKeybindings
    autocmd!
    autocmd FileType markdown nnoremap g; g$
augroup END
]])

-- sourcing neovim directly from command
nmap("<C-\\>", ":w<CR>:so %<CR>")
-- nvim tree
nmap("<C-n>", ":NvimTreeFocus<CR>")
nmap("<C-b>", ":NvimTreeToggle<CR>")

-- basic normal remappings
nmap("<leader>q", ":lua ExitBuffer()<CR>")
nmap("<leader>w", ":w<CR>")
nmap("<leader>v", ":vs<CR>")
nmap("<leader>h", ":sp<CR>")

nmap("<C-h>", "<C-w>h")
nmap("<C-l>", "<C-w>l")
nmap("<C-j>", "<C-w>j")
nmap("<C-k>", "<C-w>k")

-- better normal mode movement
nmap("gl", "$")
nmap("gh", "^")
nmap("gt", "gg")
nmap("gb", "G")

nmap("ygl", "y$")
nmap("ygh", "y^")

nmap("<C-Tab>", ":bnext<CR>")
nmap("<C-S-Tab>", ":bprevious<CR>")
nmap("<leader>tn", ":tabnext<CR>")
nmap("<leader>tp", ":tabprevious<CR>")

-- some navigation normal remappings
nmap("<C-d>", "<C-d>zz")
nmap("<C-u>", "<C-u>zz")
nmap("<C-o>", "<C-o>zz")
nmap("N", "Nzzzv")
nmap("n", "nzzzv")

-- better curly brackets manipulation(change in the future pls)
nmap("dic", "diB")
nmap("dac", "daB")
nmap("cic", "ciB")
nmap("cac", "caB")
vmap("ic", "iB")
vmap("ac", "aB")

--- better visual mode movement
vmap("gl", "$")
vmap("gh", "^")
vmap("gt", "gg")
vmap("gb", "G")

-- basic insert remappings
imap("kj", "<Esc>")
imap("<C-e>", "<C-o>$")
imap("<C-a>", "<C-o>^")
imap("<C-d>", "<C-o>o")
imap("<C-v>", '<C-r>"')

-- better replacing and handle of commands
nmap("<leader>as", ":S//g<Left><Left>")
nmap("<leader>S", ":%S//g<Left><Left>")
nmap("<leader>.", "@:<CR>")
nmap("<leader>sr", ":s//gI<Left><Left><Left>")
nmap("<leader>c", ":call Calc()<CR>")
vmap("<leader>s", ":s//g<Left><Left>")
vmap("<leader>as", ":S//g<Left><Left>")

-- terminal mappings
tmap("<C-j>", "<C-\\><C-N><C-w>j")
tmap("<C-k>", "<C-\\><C-N><C-w>k")
tmap("<C-S-h>", ":vertical resize -2<CR>")
tmap("<C-S-j>", ":resize +2<CR>")
tmap("<C-S-k>", ":resize -2<CR>")
tmap("<C-S-l>", ":vertical resize +2<CR>")

-- telescope keybindings
nmap("<leader>f", ":Telescope find_files<CR>")
nmap("<leader>tt", ":Telescope live_grep<CR>")
nmap("<leader>p", ":Telescope workspaces<CR>")
-- r from repo
nmap("<leader>rf", ":Telescope git_files<CR>")
nmap("ma", ":Telescope vim_bookmarks current_file<CR>")
-- until i start using you more
-- nmap("<leader>r", ":Telescope neoclip<CR>")

-- dadbod keybindings
nmap("<leader><leader>db", ":tab DBUI<CR>")

-- resizing windows
nmap("<C-S-h>", ":vertical resize -2<CR>")
nmap("<C-S-j>", ":resize -2<CR>")
nmap("<C-S-k>", ":resize +2<CR>")
nmap("<C-S-l>", ":vertical resize +2<CR>")

-- fugitive keybindings
nmap("<leader>ga", ":G add<space>")
nmap("<leader>gw", ":Gwrite<CR>")
nmap("<leader>gc", ":G commit<CR>")
nmap("<leader>gu", ":G reset %<CR>")
nmap("<leader>gl", ":G log<CR><C-w>L<CR>")
nmap("<leader>gs", ":Telescope git_status<CR>")
nmap("<leader>gb", ":Telescope git_branches<CR>")
nmap("<leader>gps", ":G push<space>")
nmap("<leader>gpl", ":G pull origin<space>")
nmap("<leader>gnb", ':G checkout -b ""<left>')

-- bufferline navigation
nmap("<S-l>", ":bnext<CR>")
nmap("<S-h>", ":bprevious<CR>")

-- octo mappings
nmap("<leader>opl", ":Octo pr list<CR>")
nmap("<leader>ope", ":Octo pr edit<space>")
-- harpoon mappings
nmap("<leader>ss", ":lua require('harpoon.ui').toggle_quick_menu()<CR>")
nmap("<leader>sa", ":lua require('harpoon.mark').add_file()<CR>")
nmap("<leader>su", ":lua require('harpoon.ui').nav_file(1)<CR>")
nmap("<leader>si", ":lua require('harpoon.ui').nav_file(2)<CR>")
nmap("<leader>so", ":lua require('harpoon.ui').nav_file(3)<CR>")
nmap("<leader>sp", ":lua require('harpoon.ui').nav_file(4)<CR>")

return M
