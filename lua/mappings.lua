-- mapping functions based on: https://github.com/arnvald/viml-to-lua/blob/main/lua/mappings.lua (checkout his repo is very informative)
table.unpack = table.unpack or unpack -- 5.1 compatibility
function nmap(shortcut, command, opts)
	if opts == nil then
		opts = {}
	end
	map("n", shortcut, command, opts)
end

function imap(shortcut, command, opts)
	if opts == nil then
		opts = {}
	end
	map("i", shortcut, command, opts)
end

function vmap(shortcut, command, opts)
	if opts == nil then
		opts = {}
	end
	map("v", shortcut, command, opts)
end

function cmap(shortcut, command, opts)
	if opts == nil then
		opts = {}
	end
	map("c", shortcut, command, opts)
end

function tmap(shortcut, command, opts)
	if opts == nil then
		opts = {}
	end
	map("t", shortcut, command, opts)
end

function unmap(mode, shortcut)
	vim.api.nvim_del_keymap(mode, shortcut)
end

function map(mode, shortcut, command, opts)
	-- vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
	local count = 0
	for _ in pairs(opts) do
		count = count + 1
	end

	local list = { noremap = true, silent = true }
	list = vim.tbl_extend("force", list, opts)
	vim.keymap.set(mode, shortcut, command, list)
end

local M = {}
M.nmap = nmap
M.imap = imap
M.vmap = vmap
M.cmap = cmap
M.tmap = tmap
M.unmap = unmap

function ExitBuffer()
	if vim.bo.filetype == "TelescopePrompt" then
		vim.cmd("quit!")
		return
	end
	if vim.bo.buftype == "terminal" then
		vim.cmd("bd!")
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

-- basic normal remappings
nmap("<leader>q", ":lua ExitBuffer()<CR>")
nmap("<leader>Q", ":%bd|e#<CR>")
nmap("<leader>w", function()
	vim.cmd("w")
	local filetype = vim.bo.filetype
	if filetype == "octo" or filetype == "vimwiki" or filetype == "markdown" then
		return
	end
	vim.cmd("e")
end)
nmap("<leader>v", ":vs<CR>")
nmap("<leader>h", ":sp<CR>")
nmap("<leader>5", "%")
nmap(",", "%")

nmap("<C-h>", "<C-w>h")
nmap("<C-l>", "<C-w>l")
nmap("<C-j>", "<C-w>j")
nmap("<C-k>", "<C-w>k")

-- better normal mode movement
nmap("gl", "g$")
nmap("gh", "g^")
nmap("gt", "gg")
nmap("gb", "G")

nmap("ygl", "y$")
nmap("ygh", "y^")

nmap("<C-Tab>", ":tabnext<CR>")
nmap("<C-S-Tab>", ":tabprevious<CR>")
-- nmap("<leader>tn", ":tabnext<CR>")
-- nmap("<leader>tp", ":tabprevious<CR>")

-- some navigation normal remappings
nmap("j", "gj")
nmap("k", "gk")
vmap("j", "gj")
vmap("k", "gk")
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
vmap("gl", "g$")
vmap("gh", "g^")
vmap("gt", "gg")
vmap("gb", "G")

-- basic insert remappings
imap("kj", "<Esc>")
imap("<C-e>", "<C-o>$")
imap("<C-a>", "<C-o>^")
imap("<C-d>", "<C-o>o")
imap("<C-v>", "<C-r>+")

-- better replacing and handle of commands
nmap("<leader>.", "@:<CR>")
nmap("<leader>s", ":s//gI<Left><Left><Left>")
vmap("<leader>s", ":s//g<Left><Left>")

-- terminal mappings
tmap("<C-j>", "<C-\\><C-N><C-w>j")
tmap("<C-k>", "<C-\\><C-N><C-w>k")
tmap("<C-h>", "<C-\\><C-N><C-w>h")
tmap("<C-n>", "<C-\\><C-N>")
tmap("<C-q>", "<C-\\><C-N>:bd!<CR>")
tmap("<C-S-h>", "<C-\\><C-N>:vertical resize -2<CR>")
tmap("<C-S-j>", "<C-\\><C-N>:resize +2<CR>")
tmap("<C-S-k>", "<C-\\><C-N>:resize -2<CR>")
tmap("<C-S-l>", "<C-\\><C-N>:vertical resize +2<CR>")

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
nmap("<leader>gps", ":G push<space>")
nmap("<leader>gpl", ":G pull origin<space>")
nmap("<leader>gnb", ':G checkout -b ""<left>')
nmap("<leader>gr", ":G rebase -i HEAD~")
nmap("<leader>gk", ":G checkout -- %")
nmap("<leader>gd", ":Gvdiff")

-- mappings when gitdiff for custom insertions/deletions within a single file
vmap("<leader>gw", ":diffput<CR>")

-- vim bookmark mappings
nmap("mm", "zz:BookmarkToggle<CR>")
nmap("mn", ":BookmarkNext<CR>zz")
nmap("mp", ":BookmarkPrev<CR>zz")

-- bufferline navigation
nmap("<S-l>", ":bnext<CR>")
nmap("<S-h>", ":bprevious<CR>")

-- vira mappings(example of conditional remappings)
-- vim.cmd([[
--   augroup vira_buffer_mappings
--     autocmd!
--     autocmd FileType vira_menu nnoremap <leader>jy :execute "!$HOME/.local/bin/branch_name " shellescape(getline('.'),1)<CR>
--   augroup END
-- ]])

-- custom commands mappings
nmap("<leader>rr", ":ExecuteCurrentBuffer<CR>")
nmap("<leader>cp", ":CopyGitPath<CR>")
nmap("<leader>cc", ":PrintBufferPath<CR>")
nmap("<leader>cP", ":CopyFullPath<CR>")
nmap("<leader>Cp", ":lua copy_buffer_path(nil,true)<CR>")
nmap("<leader>CP", ":lua copy_buffer_path(true,true)<CR>")
vmap("<leader>cp", ":<C-U>lua copy_buffer_path(nil,true)<CR>")
vmap("<leader>cP", ":<C-U>lua copy_buffer_path(true,true)<CR>")
nmap("<C-y>", function()
	vim.cmd(":%y+")
	print("Buffer copied to clipboard")
end)
vim.keymap.set({ "n", "x", "o" }, "ms", "<Plug>(leap-backward-to)")

return M
