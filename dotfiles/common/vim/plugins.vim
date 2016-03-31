" Install vim-plug  
if empty(glob("~/.vim/autoload/plug.vim"))
    " Ensure all needed directories exist  (Thanks @kapadiamush)
    execute '!mkdir -p ~/.vim/plugged'
    execute '!mkdir -p ~/.vim/autoload'
    " Download the actual plugin manager
    execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

" Don't forget to run PlugInstall for new plugin
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
"Plug 'raimondi/delimitmate'
Plug 'majutsushi/tagbar'
Plug 'rodjek/vim-puppet'
Plug 'scrooloose/syntastic'
Plug 'SirVer/ultisnips', { 'on': [] }
Plug 'honza/vim-snippets'
Plug 'edsono/vim-matchit'
Plug 'tpope/vim-ragtag'
Plug 'kien/ctrlp.vim'
Plug 'godlygeek/tabular'
Plug 'vim-scripts/closetag.vim'
"Plug 'valloric/youcompleteme'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

"" Extra plugin config

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_pylint_args = "--load-plugins pylint_django"

hi SpellBad cterm=bold ctermbg=red guibg=LightYellow
hi SpellCap cterm=bold ctermbg=red guibg=LightYellow



" Youcompleteme
"let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
"let g:ycm_confirm_extra_conf = 0
"let g:ycm_filetype_specific_completion_to_disable = {
"  \ 'cpp': 1,
"  \ 'c': 1
"  \ }

"utlisnip
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-f>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

"https://github.com/junegunn/vim-plug/issues/48
augroup load_ultisnips
    autocmd!
    autocmd InsertEnter * call plug#load('ultisnips') | autocmd! load_ultisnips
augroup END

let g:closetag_filenames = "*.html,*.xhtml,*.phtml"
