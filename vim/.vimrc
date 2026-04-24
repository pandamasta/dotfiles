" author          :Aurelien Martin
" description     :My vimrc written from scratch based on vimdoc and tricks found on the web
"
"=============================
" Simple & Clean vimrc
"=============================

set nocompatible
syntax on
set background=dark
if has('termguicolors')
  set termguicolors
else
  set t_Co=256
endif

"=============================
" Plugins (vim-plug)
"=============================

if has('nvim')
  let data_dir = stdpath('data') . '/site'
else
  let data_dir = expand('~/.vim')
endif
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'dense-analysis/ale'
call plug#end()

"=============================
" Basic Settings
"=============================

set backspace=indent,eol,start
set autoindent
set history=200
set showcmd
set ruler
set incsearch
set hlsearch
set ignorecase smartcase
set number
set mouse=nvc
set scrolloff=3
set showmatch
set clipboard=unnamed,unnamedplus
set hidden
set splitbelow splitright
set path=.,**
set wildmenu
set wildignore+=**/.git/**,**/__pycache__/**,**/venv/**,**/node_modules/**
set wildignore+=*.o,*.pyc,*.swp

"=============================
" Tabs & Indent
"=============================

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

"=============================
" Folding – SIMPLE
"=============================

set foldmethod=indent
set foldlevelstart=0           " Start with all folds closed
set foldenable
nnoremap <silent> <space> za   " <Space> = open/close fold

" Fold look
hi Folded ctermbg=236 ctermfg=250 guibg=#303030 guifg=#b2b2b2

"=============================
" Backup / Swap / Undo
"=============================

if has('nvim')
  let s:vim = stdpath('data')
else
  let s:vim = expand('~/.vim')
endif
for dir in ['backup', 'swap', 'undo']
  let path = s:vim . '/' . dir
  if !isdirectory(path) | call mkdir(path, 'p') | endif
endfor

let &backupdir = s:vim . '/backup'
let &directory = s:vim . '/swap'
let &undodir   = s:vim . '/undo'
set nobackup nowritebackup
set noswapfile
set undofile

"=============================
" Filetypes
"=============================

filetype on
filetype plugin on
filetype indent on

augroup filetypes
  autocmd!
  autocmd FileType vim,sh,bash setlocal ts=2 sw=2 sts=2
  autocmd FileType python,c,go setlocal ts=4 sw=4 sts=4
  autocmd FileType python setlocal textwidth=88
augroup END

"=============================
" ALE – Only when you press a key
"=============================

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 0
let g:ale_fix_on_save = 0

let g:ale_linters = {
\   'sh': ['shellcheck'],
\   'bash': ['shellcheck'],
\   'python': ['flake8'],
\   'c': ['clang'],
\   'go': ['golint', 'govet']
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['black', 'isort'],
\   'c': ['clang-format'],
\   'go': ['gofmt', 'goimports']
\}

" <leader>a = lint, <leader>f = fix
let mapleader = ","
nnoremap <silent> <leader>a :ALELint<CR>
nnoremap <silent> <leader>f :ALEFix<CR>

"=============================
" Key Mappings
"=============================

nnoremap <silent> <C-p> :Files<CR>
nnoremap <F5> :Lexplore<CR>
nnoremap <F2> :set invnumber<CR>
nnoremap <F3> :set invlist<CR>
nnoremap <F7> :set invpaste<CR>
nnoremap <F8> :w<CR>:term python %<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Indent keep selection
vnoremap < <gv
vnoremap > >gv

" Trim whitespace
function! TrimSpaces() range
  let l:save = winsaveview()
  keeppatterns silent! execute a:firstline.','.a:lastline.'s/\s\+$//e'
  call winrestview(l:save)
endfunction
command! -range=% TrimSpaces <line1>,<line2>call TrimSpaces()
nnoremap <silent> <F6> :TrimSpaces<CR>

"=============================
" Statusline
"=============================

set statusline=%F\ %M\ %Y\ %R
set statusline+=%=
set statusline+=\ %l:%c\ %p%%
set laststatus=2

"=============================
" Colors & Highlights
"=============================

hi Search     ctermfg=Black ctermbg=Yellow cterm=bold
hi IncSearch  ctermfg=Black ctermbg=Cyan   cterm=bold
"hi ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
"match ExtraWhitespace /\s\+$/

hi Visual cterm=NONE ctermbg=Blue ctermfg=White gui=NONE guibg=#005f87 guifg=#ffffff

autocmd FileType markdown setlocal nospell
hi link markdownError NONE
hi markdownItalic cterm=none gui=none
hi markdownBold   cterm=bold gui=bold


" Define highlight group immediately
highlight ExtraWhitespace ctermbg=red guibg=lightred

" Apply to all buffers safely
autocmd BufWinEnter,BufReadPost * match ExtraWhitespace /\s\+$/

" Ensure it survives colorscheme changes
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=lightred

" Show visible trailing spaces
set list
set listchars=tab:>-,trail:·,extends:>,precedes:<,nbsp:+


"=============================
" Tags (Python & Go)
"=============================

set tags=./.tags;,tags

function! GeneratePythonTags()
  !ctags -R --languages=Python --python-kinds=-iv --exclude=migrations,__pycache__,.git,.venv -f .tags .
  echo "Python tags done"
endfunction

function! GenerateGoTags()
  !gotags -R -f .tags .
  echo "Go tags done"
endfunction

nnoremap <leader>gt :call GeneratePythonTags()<CR>
nnoremap <leader>gT :call GenerateGoTags()<CR>

