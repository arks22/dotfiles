"dein.vim
if &compatible
  set nocompatible
endif

let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif

execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#add(s:dein_repo_dir)
  call dein#add('Shougo/vimproc', {'build': 'make'})
  call dein#add('Shougo/vimshell')
  call dein#add('Shougo/neocomplete.vim')
  call dein#add('Shougo/unite.vim')
  call dein#add('Shougo/vimfiler')
  call dein#add('ctrlpvim/ctrlp.vim')
  call dein#add('mattn/emmet-vim')
  call dein#add('Yggdroot/indentLine')
  call dein#add('easymotion/vim-easymotion')
  call dein#add('itchyny/lightline.vim')
  call dein#add('dag/vim-fish')
  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

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

"lightline.vim
let g:lightline = {
  \ 'colorscheme': 'solarized',
  \ }


"VimFiler
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_ignore_pattern ='^\%(\.\|\..\|\.git\|\.DS_Store\|\.tmp\)$'
let g:vimfiler_tree_closed_icon = "▸"
let g:vimfiler_tree_opened_icon = "▾"
let g:vimfiler_tree_leaf_icon = "│"
let g:vimfiler_file_icon = " "
let g:vimfiler_readonly_file_icon = "⭤"
autocmd FileType vimfiler nmap <buffer> <Space> <NOP>
autocmd FileType vimfiler nmap <buffer> , <Plug>(vimfiler_toggle_mark_current_line_up)

"ctrlp.vim
let g:ctrlp_max_files  = 10000
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = { 'dir': '\(\.git\|\tmp\|\log\)', 'file': '\(\.DS_Store\|\.log\)' }


"vim-easymotion
let g:EasyMotion_do_mapping = 0

map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)
nmap s <Plug>(easymotion-overwin-f2)
vmap s <Plug>(easymotion-bd-f2)


"indentLine
let g:indentLine_faster = 1
let g:indentLine_char = "│"


"emmet
let g:user_emmet_leader_key = '<C-m>'


"etc
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

syntax enable
colorscheme solarized

set wrapscan
set hlsearch
set cursorline
set number
set ruler
set noswapfile
set expandtab
set tabstop=2
set laststatus=2
set showtabline=2
set softtabstop=2
set shiftwidth=2
set backspace=indent,eol,start
set showcmd
set wildmenu
set vb t_vb=
set autoindent
set autoindent

highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE

"maps
let mapleader = "\<Space>"

noremap <S-h> ^
noremap <S-j> }
noremap <S-k> {
noremap <S-l> $
nnoremap <Leader>s :%s/
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>n :noh<CR>
nnoremap <Leader>t :tabnew<CR>
nnoremap <Leader>u :Unite<CR>
nnoremap <Leader>e :VimFilerExplorer -winwidth=32<CR>
nnoremap <Leader>f :VimFiler -horizontal<CR>
nnoremap <Leader>p :CtrlPRoot<CR>
nnoremap <Leader>j <C-w>j
nnoremap <Leader>k <C-w>k
nnoremap <Leader>l <C-w>l
nnoremap <Leader>h <C-w>h
nnoremap <Leader>, <C-w><<C-w><<C-w><
nnoremap <Leader>. <C-w>><C-w>><C-w>>
nnoremap <Leader>+ <C-w>+<C-w>+<C-w>+
nnoremap <Leader>- <C-w>-<C-w>-<C-w>-
nnoremap <Leader>d "_d
nnoremap <Leader>D "_D
nnoremap <C-l> gt
nnoremap <C-h> gT
nnoremap <C-l> gt
nnoremap <C-h> gT
nnoremap x "_x
nnoremap ; :
nnoremap : ;
nnoremap j gj
nnoremap k gk
nnoremap Y y$
