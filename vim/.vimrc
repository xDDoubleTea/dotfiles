call plug#begin()

" List your plugins here
Plug 'jserv/nyancat.vim'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

call plug#end()

set expandtab
set enc=utf8
set hls
set mouse=nv
set nu
set relativenumber
set autochdir
set tabstop=4
syntax on

map <C-s> <CMD>w <CR>
map <C-e> <CMD>NERDTreeToggle<CR>

let g:nyancat_scale = 1.5
