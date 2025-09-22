" Basic settings
syntax on
set number
set tabstop=2             " Number of spaces tabs count for
set shiftwidth=2          " Number of spaces to use for autoindent
set expandtab             " Use spaces instead of tabs
set autoindent            " Copy indent from current line when starting a new one
set background=dark
set nocompatible          " Disable Vi compatibility
set nowrap                " Don't wrap long lines

" Search
set incsearch             " Incremental search
set hlsearch              " Highlight search results
set ignorecase            " Ignore case in searches...
set smartcase             " ...unless capital letters are used

" Filetype detection & indentation
filetype on
filetype plugin on
filetype indent on

" Editing behavior
set backspace=indent,eol,start  " Make backspace behave nicely
set showmatch                  " Highlight matching brackets/parens

" Undo & history
set undofile
set undodir=~/.vim/undo

" UI
set laststatus=2          " Always show statusline
set scrolloff=5           " Keep 5 lines visible above/below cursor
set sidescrolloff=5       " Keep 5 columns visible left/right of cursor
set mouse=a               " Enable mouse support

