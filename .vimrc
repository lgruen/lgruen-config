set nocompatible

syntax on " syntax highlighting
set t_Co=256 " Enable 256 colors, see http://vim.wikia.com/wiki/256_colors_in_vim.
set background=light
colorscheme default

" font
"set guifont=Bitstream\ Vera\ Sans\ Mono\ 9

" indenting
set smartindent
set autoindent
set smarttab

set ic " ignore case in search
set incsearch " incremental search
set hlsearch " highlight search results
set smartcase " ignore case when lowercase

" expand tabs
set tabstop=8
set shiftwidth=4
set expandtab
setlocal textwidth=80

" don't insert comment leader automatically on new line
autocmd BufRead,BufNewFile * set formatoptions-=cro

" don't want comments at the beginning of the line in python
au BufNewFile,BufRead *.py set nocindent
au BufNewFile,BufRead *.py set nosmartindent
au BufNewFile,BufRead *.py set autoindent

" don't want strange indenting for LaTeX files
au BufNewFile,BufRead *.tex set nosmartindent

" treat SConstruct as python
au BufNewFile,BufRead SConstruct set filetype=python

" underscore as word delimiter
"set iskeyword-=_

" show full path of file
:map <C-f> 1<C-g>

" don't jump over text-wrapped lines
map j gj
map k gk

" this turns off physical line wrapping (ie: automatic insertion of newlines)
set textwidth=0 wrapmargin=0

" Turn of highlighting after a search
map ,, :nohl<CR>

" compilation
"map <F7> :make!<CR>
"map <C-Left> :cp<CR>
"map <C-Right> :cn<CR>

" rewrap current paragraph
"map <C-q> {gq}

" backup options
" set backupdir=~/tmp " backups (~)
" set directory=~/tmp " swap files
" set backup " enable backups
" swap files are more trouble than they're worth,
" and they increase start-up time a lot on some file systems.
" setting updatecount=0 prevents them being created
set updatecount=0

" change directory automatically
set autochdir

" filename auto completion
set wildmode=longest:full
set wildmenu

" show line numbers
set ruler

" delete to the left in insert mode with backspace
set backspace=indent,eol,start

" always have some lines of text when scrolling
set scrolloff=5

" ctags tutorial
" http://www.vim.org/tips/tip.php?tip_id=94
" omnicpp auto completion
" http://www.vim.org/scripts/script.php?script_id=1520
"filetype plugin on
" create ctags
"map <c-f12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .
" no automatic popup for '.', '->'
"let OmniCpp_MayCompleteDot = 0
"let OmniCpp_MayCompleteArrow = 0
" other stuff
"let OmniCpp_LocalSearchDecl = 1
"let OmniCpp_ShowPrototypeInAbbr = 1
" close preview window automatically
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif
" use STL sources using the _GLIBCXX_STD macro
"let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" use system-wide tags created with
" ctags -R --c++-kinds=+p --fields=+iaS --extra=+q -o ~/system.tags /usr/include
"set tags+=~/system.tags

" no menu / toolbar / scrollbars
set guioptions-=r
set guioptions-=l
set guioptions-=m
set guioptions-=T

" stop blinking cursor
set guicursor=a:blinkon0

" Disable autocompletion preview window
set completeopt-=preview

" Don't automatically extend comments.
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Use Caps_Lock as Escape
" --- add to ~/.Xmodmap: ---
" remove Lock = Caps_Lock
" keysym Caps_Lock = Escape
