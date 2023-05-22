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

function ExitBuffer()
	if vim.bo.filetype == "TelescopePrompt" then
		vim.cmd("quit!")
		return
	end
	local win_amount = #vim.api.nvim_tabpage_list_wins(0)

	if win_amount <= 1 then
		vim.cmd("Bdelete")
		return
	end
	vim.cmd("quit")
end

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

-- better mark navigation
MarkToggling = function()
	if vim.bo.filetype == "qf" then
		vim.cmd("q")
		return
	end
	vim.cmd("MarksQFListBuf")
end
nmap("gm", "'")
nmap(",m", ":lua MarkToggling()<CR>")

-- better replacing and handle of commands
nmap("<leader>s", ":S//g<Left><Left>")
nmap("<leader>S", ":%S//g<Left><Left>")
nmap("<leader>.", "@:<CR>")
nmap("<leader>s", ":s//gI<Left><Left><Left>")
nmap("<leader>a", ":call Calc()<CR>")
vmap("<leader>s", ":S//g<Left><Left>")

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
nmap("<leader>rp", ":Telescope repo list<CR>")
-- r from repo
nmap("<leader>rf", ":Telescope git_files<CR>")
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
nmap("<leader>gl", ":G log<CR><C-w>L<CR>")
nmap("<leader>gs", ":Telescope git_status<CR>")

-- bufferline navigation
nmap("<S-l>", ":bnext<CR>")
nmap("<S-h>", ":bprevious<CR>")
