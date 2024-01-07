syntax on
set number
set relativenumber

" Use system clipboard
set clipboard=unnamed
set clipboard+=unnamedplus

" better normal mode movement
nnoremap gl $
nnoremap gh ^
nnoremap gt gg
nnoremap gb G
vnoremap gl $
vnoremap gh ^
vnoremap gt gg
vnoremap gb G


" vim basic remappings
let mapleader = " "
nnoremap <leader>q :q<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>v :vs<CR>
nnoremap <leader>h :sp<CR>
inoremap kj <Esc>
inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>^

nnoremap <leader>s :s//g<Left><Left>
nnoremap <leader>S :%s//g<Left><Left>
vnoremap <leader>s :s//g<Left><Left>

nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap <C-o> <C-o>zz
nnoremap N Nzzzv
nnoremap n nzzzv

" better split management
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
