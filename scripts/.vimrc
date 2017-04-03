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

filetype plugin indent on   "Enable filetype detection

" http://items.sjbach.com/319/configuring-vim-right
set hidden		"Manage multiple buffers effectively

" ========================= Turn Off Swap Files ==============================
set noswapfile
set nobackup
set nowb

" ============================= Indentation ==================================
set autoindent
set smartindent
set smarttab
"set shiftwidth=2
"set softtabstop=2
"set tabstop=4
"set expandtab
set pastetoggle=<F3>    "Toggle paste mode with F3; turns off autoindent, etc.
  
" ============================== Scrolling ===================================
set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ============================================================================
" ======================== Install 3rd Party Plugins =========================
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'

" Commands
Plug 'tpope/vim-surround'

" Completion
Plug 'valloric/youcompleteme', {'do': './install.py'}

" =========================== Syntastic settings =============================
Plug 'scrooloose/syntastic'     "Syntax checker

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

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