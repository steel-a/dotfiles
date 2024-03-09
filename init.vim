" Global Sets """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on            " Enable syntax highlight
set t_Co=256         " 256 colors
"colors zenburn
"colorscheme atom-dark-256

set foldmethod=indent
set foldlevel=99
nnoremap <space> za
au BufNewFile, BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=84
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix
set nu               " Enable line numbers
set tabstop=4        " Show existing tab with 4 spaces width
set softtabstop=4    " Show existing tab with 4 spaces width
set shiftwidth=4     " When indenting with '>', use 4 spaces width
set expandtab        " On pressing tab, insert 4 spaces
set smarttab         " insert tabs on the start of a line according to shiftwidth
set smartindent      " Auto inserts 1 extra level of indentation in some cases
set hidden           " Hides the current buffer when a new file is openned
set incsearch        " Incremental search
set ignorecase       " Ingore case in search
set smartcase        " Consider case if there is a upper case character
set scrolloff=8      " Minimum number of lines to keep above and below the cursor
set colorcolumn=84   " Draws a line at the given line to keep aware of the line size
set signcolumn=yes   " Add a column on the left. Useful for linting
set cmdheight=1      " Give more space for displaying messages
set updatetime=100   " Time in miliseconds to consider the changes
set encoding=utf-8   " The encoding should be utf-8 to activate the font icons
set nobackup         " No backup files
set nowritebackup    " No backup files
set splitright       " Create the vertical splits to the right
set splitbelow       " Create the horizontal splits below
set autoread         " Update vim after file update from outside
set mouse=a          " Enable mouse support
filetype on          " Detect n set the filetype option n trigger the FileType Event
filetype plugin on   " Load the plugin file for the file type, if any
filetype indent on   " Load the indent file for the file type, if any

" Guias
" https://www.manualdocodigo.com.br/vim-basico/
" https://www.manualdocodigo.com.br/vim-python/
" https://www.youtube.com/watch?v=4BnVeOUeZxc
call plug#begin()
Plug 'preservim/nerdtree'
Plug 'dense-analysis/ale'   "Lint Engine
Plug 'davidhalter/jedi-vim' "Autocomplete
Plug 'sheerun/vim-polyglot'

Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python'
Plug 'rcarriga/nvim-dap-ui'
Plug 'ldelossa/nvim-dap-projects'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

"Plug 'jnurmine/Zenburn'
Plug 'sainnhe/sonokai'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'

call plug#end()

" Remaps """""""""""""""""""'"
nmap <C-a> :NERDTreeToggle<CR>

" Shortcuts for split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Executa o arquivo que o cursor está no momento
nnoremap tp :!python3 %<cr>

lua require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
nnoremap <silent> <leader>dn :lua require('dap-python').test_method()<CR>
nnoremap <silent> <leader>df :lua require('dap-python').test_class()<CR>
vnoremap <silent> <leader>ds <ESC>:lua require('dap-python').debug_selection()<CR>
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
"let g:ale_python_black_options = '--line-length 84'
let g:ale_python_isort_options = '--profile black -l 84'


" Themes """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

"colors zenburn
"colorscheme atom-dark-256
let g:sonokai_style = 'espresso'
let g:sonokai_enable_italic = 1
let g:sonokai_disable_italic_comment = 0
let g:sonokai_diagnostic_line_highlight = 1
let g:sonokai_current_word = 'bold'
colorscheme sonokai

if (has("nvim")) "Transparent background. Only for nvim
    highlight Normal guibg=NONE ctermbg=NONE
    highlight EndOfBuffer guibg=NONE ctermbg=NONE
endif

" AirLine """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_theme = 'sonokai'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
