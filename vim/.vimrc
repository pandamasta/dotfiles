" author          :Aurelien Martin
" description     :My vimrc written from scratch based on vimdoc and tricks found on the web


set nocompatible               " Vim working in an improved way. Must be first option

"""""""""""""""""""""" Source file if plugins

if filereadable(glob("$HOME/.vim/plugins.vim"))
    source $HOME/.vim/plugins.vim
endif


"""""""""""""""""""""" Global setup

syntax on                      " Add syntax highlighting

colorscheme desert
set t_Co=256                    " 16 color mode
set background=dark            " Background colors
set backspace=indent,eol,start " Behavior of backspace
set autoindent                 " Use the indent of the previous line for a newly created line
set backup                     " Keep a backup copy of a file when overwriting it
set history=100                " Keep commands and search patterns in the history
set undolevels=150             " Number of cached undo
set showcmd                    " Display an incomplete command in the lower right corner of the Vim window
set ruler                      " Display the current cursor position in the lower right corner
set incsearch                  " Display the match for a search pattern
set hlsearch                   " Highlight the search
set cmdheight=1                " Hight of the command bar
set autoread                   " Read when a file is changed from the outside
set showmatch		           " Show matching brackets.
set number                     " Line number
set noerrorbells               " No bells on errors
set novisualbell               " No bells on visual errors
set listchars=tab:>-,trail:-   " How display tab looks
set filetype=unix              " Unix as the standard file type
set mouse-=a                   " Enable mouse support (scrolling,copy...)

""""""""""""""""""""" Fold and tab

set foldmethod=indent                               " Fold by indented block
set tabstop=4                  " 4 spaces for tab
set shiftwidth=4               " 4 spaces for reindent
set softtabstop=4              " 4 columns for <tab>
set expandtab                  " Create spaces when I type <tab>


""""""""""""""""""""" Backup
set nobackup       " Keep backup file
set nowritebackup  "
set noswapfile     "
set directory=$HOME/.vim/swapdir//
set backupdir=$HOME/.vim/backupdir//


""""""""""""""""""""" Color tunnings

highlight Pmenu ctermfg=0 ctermbg=3 " Menu color
highlight PmenuSel ctermfg=0 ctermbg=7 "  Menu selection color
highlight MatchParen ctermbg=darkblue guibg=blue " Parenthesis matching color
hi Search ctermfg=Yellow ctermbg=NONE cterm=bold,underline

"""""""""""""""""""""" Explorer
"Ctrl + 6 in order to return to last buffer
let g:netrw_liststyle=3 "Explorer style
let g:netrw_winsize=18

"""""""""""""""""""""" Keymap
let mapleader="\\" "Backlash as leader key
map <leader>k :Vexplore<cr>
nnoremap <F2> :set nu!<CR>   " Display num
nnoremap <F3> :set list!<CR>   " Display tab
nnoremap <F4> :set foldmethod=indent <CR> " Fold idented blocks
nnoremap <F5> :Lexplore <CR> " Native VIM explorer
nnoremap <F7> :NERDTreeToggle <CR> " Native VIM explorer
nnoremap <F8> :!clear;python %<CR>
nmap <F9> :TagbarToggle<CR>
set pastetoggle=<F7>


""""""""""""""""""""" Functions

"See white space before chariot return
function ShowSpaces(...)
  let @/='\v(\s+$)|( +\ze\t)'
  let oldhlsearch=&hlsearch
  if !a:0
    let &hlsearch=!&hlsearch
  else
    let &hlsearch=a:1
  end
  return oldhlsearch
endfunction

" Remove/Replace white space chariot return
function TrimSpaces() range
  let oldhlsearch=ShowSpaces(1)
  execute a:firstline.",".a:lastline."substitute ///gec"
  let &hlsearch=oldhlsearch
endfunction

command -bar -nargs=? ShowSpaces call ShowSpaces(<args>)
command -bar -nargs=0 -range=% TrimSpaces <line1>,<line2>call TrimSpaces()
nnoremap <F12>     :ShowSpaces 1<CR>
nnoremap <S-F12>   m`:TrimSpaces<CR>``
vnoremap <S-F12>   :TrimSpaces<CR>

" Show trailing whitepace and spaces before a tab:
:highlight ExtraWhitespace ctermbg=red guibg=red
:autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/
