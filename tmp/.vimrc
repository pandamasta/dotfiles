"
" My lovelly vimc
"
"
" Plugin section

call plug#begin()
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'preservim/tagbar'
Plug 'dense-analysis/ale'
call plug#end()

"""" Remap for plugin

nnoremap <silent> <C-f> :Files<CR>


""""  Usual vimconfig

set nocompatible
set number
syntax on
colorscheme desert
set background=dark
set history=1000

"
" Swap undo backup
" mkdir ~/.vim/.backup ~/.vim/.swp ~/.vim/.undo
"



"
" Search
"

set ignorecase
set smartcase
set hlsearch

hi Search ctermbg=Black
hi Search ctermfg=Red
hi ExtraWhitespace ctermbg=darkgreen guibg=lightgreen

match ExtraWhitespace /\s\+$/



set path=$PWD/**        " enable fuzzy finding in the vim command line
set wildmenu            " enable fuzzy menu
set wildignore+=**/.git/**,**/__pycache__/**,**/venv/**,**/node_modules/**,**/dist/**,**/build/**,*.o,*.pyc,*.swp
set wildignore+=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx


"
" Backup, swap
"

"set nobackup
"set noswapfile

set undodir=~/.vim/.undo//
set backupdir=~/.vim/.backup//
set directory=~/.vim/.swp/

"
" Cursor
"

set scrolloff=3
set cursorline

set showmatch


"
" Identation
"

set tabstop=4
set shiftwidth=4
set autoindent
set expandtab " Always use space instead of tab


filetype on
filetype indent on
filetype plugin on

"Python Settings
"autocmd FileType python set softtabstop=4
"autocmd FileType python set tabstop=4
"autocmd FileType python set autoindent
"autocmd FileType python set expandtab
"autocmd FileType python set textwidth=80
"autocmd FileType python set smartindent
"autocmd FileType python set shiftwidth=4

autocmd FileType vim setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType sh setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4



"
" Folding
"

set foldmethod=indent
nnoremap <space> za
vnoremap <space> zf

"
" Status bar
"

" Clear status line when vimrc is reloaded.
set statusline=

" Status line left side.
set statusline+=\ %F\ %M\ %Y\ %R

" Use a divider to separate the left side from the right side.
set statusline+=%=

" Status line right side.
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%

" Show the status on the second to last line.
set laststatus=2


" Color
"

hi DiffAdd      gui=none    guifg=NONE          guibg=#bada9f
hi DiffChange   gui=none    guifg=NONE          guibg=#e5d5ac
hi DiffDelete   gui=bold    guifg=#ff8080       guibg=#ffb0b0
hi DiffText     gui=none    guifg=NONE          guibg=#8cbee2



"
" Remap
"

" Move between window with ctrl

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>


"" Plugin Management

"curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
"if empty(glob(data_dir . '/autoload/plug.vim'))
"  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
"  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
"endif

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
     \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Fuzy finder shortcut
"nnoremap <silent> <C-p> :fzf<CR>

" Load all plugins now.
"
" " Plugins need to be added to runtimepath before helptags can be generated.
"
"packloadall
"
" " Load all of the helptags now, after plugins have been loaded.
"
" " All messages and errors will be ignored.
"
"silent! helptags ALL
"
