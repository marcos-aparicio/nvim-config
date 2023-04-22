" vim airline configurations
" let g:airline#extensions#tabline#left_alt_sep = ''

let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_sep = ''

let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''

let g:airline_left_sep = ''
let g:airline_left_sep = ''

let g:airline_right_sep = ''
let g:airline_right_sep = ''


let g:airline_powerline_fonts = 1
let g:Powerline_symbols = 'fancy'
let g:airline_theme='ayu_dark'
let g:airline#extensions#tabline#enabled = 1

" important two lines that makes ayu work in my arch distro
" let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
" vim ayu configs

set termguicolors
let ayucolor="dark"
colorscheme ayu
"important line for transparent background"
hi Normal guibg=NONE ctermbg=NONE
syntax on
set number
set relativenumber

let g:loaded_netwr = 1
let g:loaded_netrwPlugin = 1


" tabs configurations
set tabstop=4

" Vertically center document when entering insert mode
" autocmd InsertEnter * norm zz

" Remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" Use system clipboard
set clipboard=unnamed
set clipboard+=unnamedplus


" remappings needed for c-tab and c-s-tab to work, NOTICE
set <F15>=[1;5I
set <F16>=[1;6I
nmap <F15> <C-Tab>
nmap <F16> <C-S-Tab>
imap <F15> <C-Tab>
imap <F16> <C-S-Tab>

" vim basic remappings
let mapleader = " "
nnoremap <leader>q :q<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>v :vs<CR>
nnoremap <leader>h :sp<CR>
inoremap kj <Esc>
inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>^

" noremap <Space> i_<Esc>r
" nnoremap vv V
"noremap <leader>y "+y
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap <C-o> <C-o>zz
nnoremap N Nzzzv
nnoremap n nzzzv

" better curly brackets manipulation
nnoremap dic diB
nnoremap dac daB
nnoremap cac caB
nnoremap cic ciB
vnoremap ic iB
vnoremap ac aB


" tab movement made easier
nnoremap <C-Tab> :bnext<CR>
nnoremap <C-S-Tab> :bprevious<CR>
nnoremap <leader>tn :bnext<CR>
nnoremap <leader>tp :bprevious<CR>

" better normal mode movement
nnoremap gl $
nnoremap gh ^
nnoremap gt gg
nnoremap gb G

" better visual mode movement
vnoremap gl $
vnoremap gh ^
vnoremap gt gg
vnoremap gb G

" better yanking
nnoremap ygl y$
nnoremap ygh y^

"better mark navigation
nnoremap gm '
":map <expr> gm printf('`%c zz',getchar())
nnoremap ,m :marks<CR>
" nnoremap ,dm :delmarks

" better replacing and handle of commands
nnoremap <leader>s :S//g<Left><Left>
nnoremap <leader>S :%S//g<Left><Left>
nnoremap <leader>. @:<CR>
vnoremap <leader>s :s//gI<Left><Left><Left>
nnoremap <leader>a :call Calc()<CR>

" better split management
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

lua require('plugins')
lua require('mappings')
