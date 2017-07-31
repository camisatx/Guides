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
"Use ':*y' to copy selected to clipboard and ':*p' to paste from clipboard
set clipboard=unnamedplus

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
  
" ============================== Scrolling ===================================
set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ============================ Spell Check ===================================
"set spell spelllang=en_us
"set spellfile=~/Programming/Code/Guides/scripts/vim_spelling.en.utf-8.add
" Only enable spell check in markdown files and git commit messages
autocmd BufRead,BufNewFile *.md,*.html set spell spelllang=en_us
autocmd FileType gitcommit set spell spelllang=en_us

" ============================================================================
" ======================== Install 3rd Party Plugins =========================
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'

" ========================= Surrounding Characters ===========================

Plug 'raimondi/delimitmate'		"Automatic closing characters

Plug 'tpope/vim-surround'       "Change surrounding characters easily

" ============================== YouCompleteMe ================================
" Run to install:
"   sudo apt update && sudo apt install build-essential cmake python-dev
"       python3-dev
"   ~/.vim/plugged/youcompleteme/install.py --clang-completer
Plug 'valloric/youcompleteme'

" Must use the system python package when installing youcompleteme
let g:ycm_path_to_python_interpreter = '/usr/bin/python'

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
