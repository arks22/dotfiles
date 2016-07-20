"dein.vim
if &compatible
  set nocompatible
endif

set runtimepath^=$HOME/.vim/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.cache/dein'))

call dein#add('~/.vim/repos/github.com/Shougo/dein.vim')
call dein#add('Shougo/neocomplete.vim')
call dein#add('junegunn/fzf')
call dein#add('Shougo/unite.vim')
call dein#add('Shougo/vimfiler')
call dein#add('scrooloose/nerdtree')
call dein#add('mattn/emmet-vim')
call dein#add('Yggdroot/indentLine')
call dein#add('easymotion/vim-easymotion')

call dein#end()

filetype plugin indent on



"neocomplete.vim
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 1
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
let g:neocomplete#sources#dictionary#dictionaries = { 'default' : '', 'scheme' : $HOME.'/.gosh_completions' }

if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endi

inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS>  neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>

noremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>".

function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
endfunction

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif

let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'




"vim-easymotion
let g:EasyMotion_do_mapping = 0

map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)
nmap s <Plug>(easymotion-overwin-f2)
vmap s <Plug>(easymotion-bd-f2)


"etc
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

syntax enable
colorscheme solarized


set background=dark
set cursorline
set cursorcolumn
set number 
set noswapfile
set expandtab
set tabstop=2
set showtabline=2
set softtabstop=2
set shiftwidth=2
set backspace=indent,eol,start 
set showcmd
set wildmenu
set vb t_vb=


let mapleader = "\<Space>"

let g:user_emmet_leader_key='<C-m>'
let g:indentLine_faster=1 

nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>n :noh<CR>
nnoremap <Leader>t :tabnew 
nnoremap <Leader>s :%s/
cnoremap rl source ~/.vimrc
nnoremap ; :
nnoremap : ;
nnoremap <silent><C-e> :NERDTree<CR>
noremap <S-h> ^
noremap <S-j> }
noremap <S-k> {
noremap <S-l> $
nnoremap <C-l> gt
nnoremap <C-h> gT
nnoremap j gj
nnoremap k gk
nnoremap Y y$
nnoremap <Leader>j <C-w>j
nnoremap <Leader>k <C-w>k
nnoremap <Leader>l <C-w>l
nnoremap <Leader>h <C-w>h
nnoremap <Leader>< <C-w><<C-w><<C-w><
nnoremap <Leader>> <C-w>><C-w>><C-w>>
nnoremap <Leader>+ <C-w>+<C-w>+<C-w>+
nnoremap <Leader>- <C-w>-<C-w>-<C-w>-
