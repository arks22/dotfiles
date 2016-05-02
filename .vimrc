"Dein.vimの設定
if &compatible
  set nocompatible
endif
set runtimepath^=$HOME/.vim/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.cache/dein'))
call dein#add('~/.vim/repos/github.com/Shougo/dein.vim')
call dein#add('Shougo/neocomplete.vim')
call dein#add('Shougo/unite.vim')
call dein#add('Shougo/vimfiler')
call dein#add('scrooloose/nerdtree')
call dein#add('mattn/emmet-vim')
call dein#add('Yggdroot/indentLine')
call dein#end()

filetype plugin indent on


"--------------------------------------------------------
"neocompleteの設定
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 1
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = { 'default' : '', 'scheme' : $HOME.'/.gosh_completions' }
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endi
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
"For no inserting <CR> key.
"return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
noremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>".
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
endfunction

inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

""."を押した時のやつ
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
"--------------------------------------------------------


let g:user_emmet_leader_key='<c-m>'
let g:indentLine_faster=1 "indetlineのなんか

"カーソルの形
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

"syntaxとかね
syntax enable
colorscheme solarized
set background=dark

set cursorline
set cursorcolumn
set number 
set noswapfile
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set hlsearch 
set backspace=indent,eol,start 
set showcmd
set wildmenu


"キーマップの設定
map <C-l> gt
map <C-h> gT
nnoremap j gj
nnoremap j gj
nnoremap Y y$
nnoremap s <Nop>
nnoremap <silent><C-e> :NERDTree<CR>
nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap s< <C-w><
nnoremap s> <C-w>>
nnoremap s+ <C-w>+
nnoremap s- <C-w>-
