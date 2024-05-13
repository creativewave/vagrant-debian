
" https://vimhelp.org/options.txt.html
" ------------------------------------------------------------------------------

set autoread
set backspace=eol,start,indent
set cmdheight=2
set encoding=utf8
set expandtab
set foldcolumn=1
set hlsearch
set ignorecase
set incsearch
set linebreak
set ruler
set scrolloff=7
set shiftwidth=4
set smartcase
set smarttab
set tabstop=4
set wildignore=*~,.hg\*,.git\*,*.o,*.pyc,.svn\*
set whichwrap+=<,>,h,l
set wildmenu


" https://vimhelp.org/filetype.txt.html
" ------------------------------------------------------------------------------
filetype plugin on
filetype indent on


" https://vimhelp.org/syntax.txt.html
" ------------------------------------------------------------------------------

syntax enable


" https://vimhelp.org/usr_40.txt.html
" ------------------------------------------------------------------------------

" Treat long lines as break lines
map j gj
map k gk

" :W sudo saves the file (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
