" author          :Aurelien Martin
" description     :My vimrc written from scratch based on vimdoc and tricks found on the web


set nocompatible               " Vim working in an improved way. Must be first option

"""""""""""""""""""""" Source file if plugins

"if filereadable(glob("$HOME/.vim/plugins.vim"))
"    source $HOME/.vim/plugins.vim
"endif


"""""""""""""""""""""" Global setup

syntax on                      " Add syntax highlighting

"colorscheme desert
set t_Co=256                   " 16 color mode
set background=dark            " Background colors
set backspace=indent,eol,start " Behavior of backspace
set autoindent                 " Use the indent of the previous line for a newly created line
set backup                     " Keep a backup copy of a file when overwriting it
set history=100                " Keep commands and search patterns in the history
set undolevels=150             " Number of cached undo
set showcmd                    " Display an incomplete command in the lower right corner of the Vim window
set ruler                      " Display the current cursor position in the lower right corner
set incsearch                  " Display the match for a search pattern
set cmdheight=1                " Hight of the command bar
set autoread                   " Read when a file is changed from the outside
set showmatch		               " Show matching brackets.
set number                     " Line number
set noerrorbells               " No bells on errors
set novisualbell               " No bells on visual errors
set listchars=tab:>-,trail:-   " How display tab looks
set filetype=unix              " Unix as the standard file type
set mouse-=a                   " Enable mouse support (scrolling,copy...)

""""""""""""""""""""" Cursor

set scrolloff=3
set cursorline

set showmatch


""""""""""""""""""""" Search

set hlsearch                   " Highlight the search
set ignorecase
set smartcase

hi Search ctermbg=Black
hi Search ctermfg=Red
hi ExtraWhitespace ctermbg=darkgreen guibg=lightgreen

match ExtraWhitespace /\s\+$/

""""""""""""""""""""" Fold and tab
set foldmethod=indent                               " Fold by indented block
set tabstop=4                  " 4 spaces for tab
set shiftwidth=4               " 4 spaces for reindent
set softtabstop=4              " 4 columns for <tab>
set expandtab                  " Always use space instead of tab

"nnoremap <space> za
"vnoremap <space> zf


""""""""""""""""""""" Backup
set nobackup       " Keep backup file
set nowritebackup  "
set noswapfile     "
set directory=$HOME/.vim/swapdir//
set backupdir=$HOME/.vim/backupdir//


""""""""""""""""""""" FileType

filetype on
filetype indent on
filetype plugin on


autocmd FileType vim setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType sh setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

autocmd BufRead,BufNewFile *.pp set filetype=puppet
autocmd BufRead,BufNewFile *.pp setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab textwidth=80 smarttab

"Python Settings
"autocmd FileType python set softtabstop=4
"autocmd FileType python set tabstop=4
"autocmd FileType python set autoindent
"autocmd FileType python set expandtab
"autocmd FileType python set textwidth=80
"autocmd FileType python set smartindent
"autocmd FileType python set shiftwidth=4

""""""""""""""""""""" Menu
set path=$PWD/**        " enable fuzzy finding in the vim command line
set wildmenu            " enable fuzzy menu
set wildignore+=**/.git/**,**/__pycache__/**,**/venv/**,**/node_modules/**,**/dist/**,**/build/**,*.o,*.pyc,*.swp
set wildignore+=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

highlight Pmenu ctermfg=0 ctermbg=3 " Menu color
highlight PmenuSel ctermfg=0 ctermbg=7 "  Menu selection color
highlight MatchParen ctermbg=darkblue guibg=blue " Parenthesis matching color
hi Search ctermfg=Yellow ctermbg=NONE cterm=bold,underline

"""""""""""""""""""""" Explorer
"Ctrl + 6 in order to return to last buffer
"let g:netrw_liststyle=3 "Explorer style
"let g:netrw_winsize=18

"""""""""""""""""""""" Keymap
let mapleader="\\" "Backlash as leader key

map <leader>k :Vexplore<cr>
nnoremap <F2> :set nu!<CR> "Display num
nnoremap <F3> :set list!<CR>   " Display tab
nnoremap <F4> :set foldmethod=indent <CR> " Fold idented blocks
nnoremap <F5> :Lexplore <CR> " Native VIM explorer
nnoremap <F6> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR> "Remove all trailing white space
nnoremap <F8> :!clear;python %<CR>
nmap <F9> :TagbarToggle<CR>
set pastetoggle=<F7>


" Move between window with ctrl
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


"""""""""""""""""""""" Status bar

set statusline= " Clear status line when vimrc is reloaded.
set statusline+=\ %F\ %M\ %Y\ %R "Status line left side
set statusline+=%= "Use a divider to separate the left side from the right side
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%% "Status line right side
set laststatus=2 " Show the status on the second to last line


"""""""""""""""""""""" Color

hi DiffAdd      gui=none    guifg=NONE          guibg=#bada9f
hi DiffChange   gui=none    guifg=NONE          guibg=#e5d5ac
hi DiffDelete   gui=bold    guifg=#ff8080       guibg=#ffb0b0
hi DiffText     gui=none    guifg=NONE          guibg=#8cbee2


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
