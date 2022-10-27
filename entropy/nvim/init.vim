" this is enabled by default in nvim
" filetype plugin indent on
" syntax on

" enable autocompletion of ale
let g:ale_completion_enabled = 1
" disable latex linting from ale as i've got my own plugin for that
let g:ale_linters = {'rust': ['analyzer'], 'haskell': ['hls', 'hindent'], 'tex': []}
"let g:ale_fixers = {'c': ['clang-format']}


" Initialize plugin system
call plug#begin(stdpath('data') . '/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/morhetz/gruvbox
" Plug 'morhetz/gruvbox'
Plug 'drewtempelmeyer/palenight.vim'

" Any valid git URL is allowed
Plug 'https://github.com/scrooloose/nerdcommenter.git'

" On-demand loading for languages
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'keith/swift.vim', { 'for': 'swift' }
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
Plug 'jalvesaq/Nvim-R', {'branch': 'stable', 'for': 'r'}
Plug 'rhysd/vim-llvm'

" Lingua Franca
Plug 'lf-lang/lingua-franca.vim'

Plug 'vim-syntastic/syntastic'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'justinmk/vim-sneak'
Plug 'lervag/vimtex'
Plug 'editorconfig/editorconfig-vim'
Plug 'LnL7/vim-nix'
Plug 'preservim/nerdtree'

" wayland clipboard
Plug 'jasonccox/vim-wayland-clipboard'

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" ale language server client
Plug 'dense-analysis/ale'

" Initialize plugin system
call plug#end()

" open fzf files in new tab instead of new buffer
"command! -bang -nargs=? -complete=dir Files
    "\ call fzf#vim#files(<q-args>, {'sink': 'tabedit', 'options': ['--info=inline', '--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}']}, <bang>0)

set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 0

" window switching by #
let g:airline_section_c = '[%{winnr()}] %t'
nnoremap <space>1 1<C-w>w
nnoremap <space>2 2<C-w>w
nnoremap <space>3 3<C-w>w
nnoremap <space>4 4<C-w>w
nnoremap <space>5 5<C-w>w
nnoremap <space>6 6<C-w>w
nnoremap <space>7 7<C-w>w
nnoremap <space>8 8<C-w>w
nnoremap <space>9 9<C-w>w
nnoremap <space>0 10<C-w>w

" set haskell highlighting
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

" possible setting as alternative for easymotion
" let g:sneak#label = 1

set backspace=indent,eol,start

" map the leader key to ,
let mapleader=","

let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --iglob "!.git/*"'

" Cycling through windows and tabs
" nnoremap j <C-W><C-J>
" nnoremap k <C-W><C-K>
" nnoremap l <C-W><C-L>
" nnoremap h <C-W><C-H>
" nnoremap <C-J> <C-W><C-J><C-W>_
" nnoremap <C-K> <C-W><C-K><C-W>_
" nnoremap <C-L> <C-W><C-L><C-W>\|
" nnoremap <C-H> <C-W><C-H><C-W>\|
map <leader>h :tabp<Enter>
map <leader>l :tabn<Enter>
map <C-H> :bprevious<Enter>
map <C-L> :bnext<Enter>
map <leader>f :Files<Enter>
map <leader>b :Buffers<Enter>

" fix auto-completion
set wildmenu        " show a completion menu
set wildignorecase
set wildignore=*.o,*~,*.pyc,*.aux,*.bbl,*.blg,*-blx.bib,*.log,*.out,*.run.xml,
    \*.toc,*.nav,*.snm  " ignore auxiliary files
" set completeopt-=preview

" automatically reload files changed on disk but not in buffer
set autoread
" hide buffers on switch
set hidden

" tex configuration
let g:tex_flavor='latex'
let g:vimtex_view_method = 'zathura'

" Optics
colorscheme palenight "gruvbox
set background=dark    " Setting dark mode

set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab

" keep 5 lines of context above/below the cursor (if possible)
set scrolloff=5

" Search
set hlsearch                        " Highlight all search results
set smartcase                       " Enable smart-case search
set ignorecase                      " Always case-insensitive
set incsearch                       " Searches for strings incrementally
