" Install vim-plug if it isn't already installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set autoread		"Reload files changed outside Vim
set nocompatible	"Use Vim settings instead of vi settings
set number	    	"Enable line numbers
set ruler           "Display the current cursor position in the lower right
set history=1000	"Store lots of :cmdline history
set showcmd	    	"Show incomplete cmds down the bottom
set ignorecase		"Ignore case in searches
set smartcase		"Only consider case in searches if using capital 
set wrap	    	"Wrap long lines

set colorcolumn=80	"Notate if line is over 80 characters

" http://items.sjbach.com/319/configuring-vim-right
set hidden		"Manage multiple buffers effectively

set foldmethod=indent
set nofoldenable

"Enable the clipboard use for copy and paste
"Run 'sudo apt install vim-gnome' to add clipboard to vim
"Check if vim clipboard is activated with 'vim --version'
"Use '"*y' to copy selected to clipboard and '"*p' to paste from clipboard
if system('uname -s') == "Darwin\n"
    set clipboard=unamed        "OSX
else
    set clipboard=unnamedplus   "Linux
endif

" ========================= Turn Off Swap Files ==============================
set noswapfile
set nobackup
set nowb

" ============================= Indentation ==================================
filetype plugin indent on   "Enable filetype detection
"set autoindent
"set smartindent
"set smarttab
set shiftwidth=4	    "Make indentations match to the 4 spaces of tab
"set softtabstop=4
set tabstop=4		    "Change the maximum width of tab to 4 spaces width
set expandtab		    "On pressing tab, insert 4 spaces
set pastetoggle=<F3>    "Toggle paste mode with F3; turns off autoindent, etc.

" Use 2 spaces for html, javascript files
autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd Filetype javascript setlocal ts=2 sw=2 expandtab
  
" ============================== Scrolling ===================================
set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ============================ Spell Check ===================================
"set spell spelllang=en_us
"set spellfile=~/Programming/Code/Guides/scripts/vim_spelling.en.utf-8.add
" Only enable spell check in markdown, html, tex and git commit messages
autocmd BufRead,BufNewFile *.md,*.html,*.tex set spell spelllang=en_us
autocmd FileType gitcommit set spell spelllang=en_us

" ============================================================================
" ======================== Install 3rd Party Plugins =========================
call plug#begin('~/.vim/plugged')

"Plug 'scrooloose/nerdtree'

" ========================= Surrounding Characters ===========================

Plug 'raimondi/delimitmate'		"Automatic closing characters
Plug 'tpope/vim-surround'       "Change surrounding characters easily
Plug 'luochen1990/rainbow'      "Rainbow parentheseparenthsiss
let g:rainbow_active = 1

" ============================== YouCompleteMe ================================
" Run to install:
"   sudo apt update && sudo apt install build-essential cmake python-dev
"       python3-dev
"   sudo apt install mono-complete golang nodejs default-jdk npm
"   ~/.vim/plugged/youcompleteme/install.py --all
"Plug 'valloric/youcompleteme'
" YouCompleteMe fork with integrated Tabnine
Plug 'https://github.com/tabnine/YouCompleteMe.git'

" Must use the system python package when installing youcompleteme
let g:ycm_path_to_python_interpreter = '/usr/bin/python3'

" ============================== Deep TabNine ================================
" Free version; ONLY use this OR YouCompleteMe
"Plug 'zxqfl/tabnine-vim'

" =========================== Syntastic settings =============================
Plug 'scrooloose/syntastic'     "Syntax checker

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Use flake8 if it is installed, otherwise fall back to pyflakes
let g:syntastic_python_checkers = ['flake8', 'pyflakes']
" Ignore line under-indented, and block comment not starting with '# '
let g:syntastic_python_flake8_args="--ignore=E126,E127,E128,E265,E501,E226,E266,W504"

" ============================== Git =========================================

Plug 'tpope/vim-fugitive'       "Git support within vim
Plug 'airblade/vim-gitgutter'   "Git changes shown on right side of pane

" ================================ Airline ===================================

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='luna'
set laststatus=2                    "Enable the status line by default
let g:airline_powerline_fonts = 1   "Enable airline to use powerline fonts

"Add following line to ~/.tmux.conf to allow terminal support for 256 colors
" set-option -g default-terminal "screen-256color"

"Must install powerline fonts to system in order for fancy characters to work
" https://github.com/powerline/fonts
"
" ====================== JavaScript Highlighter ==============================

Plug 'pangloss/vim-javascript'  "Base JS highlighter
Plug 'mxw/vim-jsx'              "JSX highlighter

" =========================== Color Scheme ===================================

" Set the gui colors
if (has("termguicolors"))
  set termguicolors
endif

syntax enable
set background=dark

"Plug 'tomasr/molokai'
"let g:molokai_original = 1

Plug 'flazz/vim-colorschemes'
"Pick a color theme from here:
"https://github.com/flazz/vim-colorschemes/tree/master/colors

call plug#end()

" Colorscheme calls must be after 'call plug#end()'
"colorscheme molokai
colorscheme hybrid
"colorscheme seti
"colorscheme spacegray
"colorscheme lightning

" =========================== Mac Commands ===================================
if system('uname -s') == "Darwin\n"
    set backspace=indent,eol, start
endif
