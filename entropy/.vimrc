filetype plugin indent on
syntax on

" enable autocompletion of ale
let g:ale_completion_enabled = 1
" disable latex linting from ale as i've got my own plugin for that
let g:ale_linters = { 'tex': []}


" Initialize plugin system
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/morhetz/gruvbox
Plug 'morhetz/gruvbox'

" Any valid git URL is allowed
Plug 'https://github.com/scrooloose/nerdcommenter.git'

" On-demand loading
Plug 'rust-lang/rust.vim', { 'for': 'rust' }

Plug 'vim-syntastic/syntastic'
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'keith/swift.vim', { 'for': 'swift' }
Plug 'justinmk/vim-sneak'
Plug 'lervag/vimtex'
Plug 'editorconfig/editorconfig-vim'
Plug 'LnL7/vim-nix'

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" ale language server client
Plug 'dense-analysis/ale'

" Initialize plugin system
call plug#end()

set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" possible setting as alternative for easymotion
" let g:sneak#label = 1

set backspace=indent,eol,start

" map the leader key to ,
let mapleader=","

" set filetypes
au BufRead,BufNewFile *.ohuac       setfiletype rust
au BufRead,BufNewFile *.ohuao       setfiletype json

" Cycling through windows and tabs -- made by Pius :D
" nnoremap j <C-W><C-J>
" nnoremap k <C-W><C-K>
" nnoremap l <C-W><C-L>
" nnoremap h <C-W><C-H>
" nnoremap <C-J> <C-W><C-J><C-W>_
" nnoremap <C-K> <C-W><C-K><C-W>_
" nnoremap <C-L> <C-W><C-L><C-W>\|
" nnoremap <C-H> <C-W><C-H><C-W>\|
map <C-H> :tabp<Enter>
map <C-L> :tabn<Enter>

" fix auto-completion
set wildmenu        " show a completion menu
set wildignorecase
set wildignore=*.o,*~,*.pyc,*.aux,*.bbl,*.blg,*-blx.bib,*.log,*.out,*.run.xml,
    \*.toc,*.nav,*.snm  " ignore auxiliary files
" set completeopt-=preview

" automatically reload files changed on disk but not in buffer
set autoread

" tex configuration
let g:tex_flavor='latex'
" Optics
colorscheme gruvbox
set background=dark    " Setting dark mode

set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab

" Search
set hlsearch                        " Highlight all search results
set smartcase                       " Enable smart-case search
set ignorecase                      " Always case-insensitive
set incsearch                       " Searches for strings incrementally
