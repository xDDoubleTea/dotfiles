call plug#begin()

" List your plugins here
Plug 'jserv/nyancat.vim'
Plug 'catppuccin/vim', { 'as': 'catppuccin', 'branch': 'main' }
Plug 'preservim/nerdtree'
call plug#end()

colorscheme catppuccin_mocha
set expandtab
set enc=utf8
set hls
set mouse=nv
set nu
set relativenumber
set autochdir
set tabstop=4
syntax on
" --- Indentation ---
set shiftwidth=4     " Determines the amount of whitespace to add/remove
set smartindent      " Automatically indents after { and newlines (Crucial for C++)
set autoindent       " Copies indentation from the previous line

" --- Bracketed paste inside tmux/screen (vim only enables it for xterm) ---
if &term =~ '^\(tmux\|screen\)'
    let &t_BE = "\e[?2004h"
    let &t_BD = "\e[?2004l"
    let &t_PS = "\e[200~"
    let &t_PE = "\e[201~"
endif

" --- UI & Searching ---
set cursorline       " Highlights the line your cursor is currently on
set wildmenu         " Shows a visual autocomplete menu for command line actions
set incsearch        " Highlights search results AS you type them
set ignorecase       " Searches ignore capitalization...
set smartcase        " ...UNLESS you type a capital letter
set fillchars=eob:\

" Set the Leader key to Space (like LazyVim)
let mapleader = " "

" Fast escape to Normal mode (so you don't have to reach for Esc)
inoremap jk <Esc>
inoremap kj <Esc>

" LazyVim-style split window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Clear search highlighting with <Leader> / (Space + /)
nnoremap <leader>/ :nohlsearch<CR>

map <C-s> <CMD>w <CR>
map <C-e> <CMD>NERDTreeToggle<CR>
let g:nyancat_scale = 1.5
