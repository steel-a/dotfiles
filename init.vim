" Global Sets """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on            " Enable syntax highlight
set nu               " Enable line numbers
set tabstop=4        " Show existing tab with 4 spaces width
set softtabstop=4    " Show existing tab with 4 spaces width
set shiftwidth=4     " When indenting with '>', use 4 spaces width
set expandtab        " On pressing tab, insert 4 spaces
set smarttab         " insert tabs on the start of a line according to shiftwidth
set smartindent      " Automatically inserts one extra level of indentation in some cases
set hidden           " Hides the current buffer when a new file is openned
set incsearch        " Incremental search
set ignorecase       " Ingore case in search
set smartcase        " Consider case if there is a upper case character
set scrolloff=8      " Minimum number of lines to keep above and below the cursor
set colorcolumn=84   " Draws a line at the given line to keep aware of the line size
set signcolumn=yes   " Add a column on the left. Useful for linting
set cmdheight=2      " Give more space for displaying messages
set updatetime=100   " Time in miliseconds to consider the changes
set encoding=utf-8   " The encoding should be utf-8 to activate the font icons
set nobackup         " No backup files
set nowritebackup    " No backup files
set splitright       " Create the vertical splits to the right
set splitbelow       " Create the horizontal splits below
set autoread         " Update vim after file update from outside
set mouse=a          " Enable mouse support
filetype on          " Detect and set the filetype option and trigger the FileType Event
filetype plugin on   " Load the plugin file for the file type, if any
filetype indent on   " Load the indent file for the file type, if any
	
" Guias
" https://www.manualdocodigo.com.br/vim-basico/
" https://www.manualdocodigo.com.br/vim-python/

call plug#begin()
Plug 'preservim/nerdtree'
Plug 'dense-analysis/ale'   "Lint Engine
Plug 'davidhalter/jedi-vim' "Autocomplete
call plug#end()

" Remaps """""""""""""""""""'"
nmap <C-a> :NERDTreeToggle<CR>

" Shortcuts for split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Executa o arquivo que o cursor está no momento
nnoremap tp :!python %<cr>
""""""""""""""""""""""""""""""

" autocmd """"""""""""""""""""
""""""""""""""""""""""""""""""

" ALE """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_linters = {
\   'python': ['flake8','pyright','bandit'],
\}

let g:ale_fixers = {
\   '*': ['trim_whitespace'],
\   'python': ['isort'],
\}

let g:ale_fix_on_save = 1
" Python """"""""""""""""""""""""""""""""""""""""""""""
let g:ale_python_flake8_options = '--max-line-length=84 --extend-ignore=E203'
let g:ale_python_black_options = '--line-length 84'
let g:ale_python_isort_options = '--profile black -l 84'
