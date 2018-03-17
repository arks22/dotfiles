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
  call dein#add('Shougo/vimproc.vim', {'build': 'make'})
  call dein#add('Shougo/neocomplete.vim',{'if' : has('lua')})
  call dein#add('Shougo/unite.vim')
  call dein#add('Shougo/vimfiler.vim')
  call dein#add('altercation/vim-colors-solarized')
  call dein#add('mattn/emmet-vim')
  call dein#add('Yggdroot/indentLine')
  call dein#add('easymotion/vim-easymotion')
  call dein#add('itchyny/lightline.vim')
  call dein#add('vim-jp/vital.vim')
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
  \ 'colorscheme': 'solarized'
  \ }


"unite
call unite#custom#source(
  \ 'file_rec/async', 
  \ 'ignore_pattern',
  \ '\(.DS_Store\|repos\|tmp\|gems\|vendor\|bundle\|log\|node_modules\|.png\|.svg\|.jpg\|.jpeg\|.gif\|.mv\|.mp3\|.mp4\|.sqlite3\|.map\|.min\)'
  \ )


"vimfiler
let g:vimfiler_no_default_key_mappings = 1
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_enable_auto_cd = 1
let g:vimfiler_ignore_pattern ='^\%(\.\|\..\|\.git\|\.DS_Store\|\.tmp\)$'
let g:vimfiler_tree_closed_icon = "▸"
let g:vimfiler_tree_opened_icon = "▾"
let g:vimfiler_tree_leaf_icon = "│"
let g:vimfiler_file_icon = " "
let g:vimfiler_readonly_file_icon = "⭤"
let g:vimfiler_safe_mode_by_default = 0

autocmd FileType vimfiler nmap <buffer> j <Plug>(vimfiler_loop_cursor_down)
autocmd FileType vimfiler nmap <buffer> k <Plug>(vimfiler_loop_cursor_up)
autocmd FileType vimfiler nmap <buffer> g <Plug>(vimfiler_cursor_top)
autocmd FileType vimfiler nmap <buffer> R <Plug>(vimfiler_redraw_screen)
autocmd FileType vimfiler nmap <buffer> * <Plug>(vimfiler_toggle_mark_all_lines)
autocmd FileType vimfiler nmap <buffer> c <Plug>(vimfiler_copy_file)
autocmd FileType vimfiler nmap <buffer> m <Plug>(vimfiler_move_file)
autocmd FileType vimfiler nmap <buffer> d <Plug>(vimfiler_delete_file)
autocmd FileType vimfiler nmap <buffer> r <Plug>(vimfiler_rename_file)
autocmd FileType vimfiler nmap <buffer> K <Plug>(vimfiler_make_directory)
autocmd FileType vimfiler nmap <buffer> N <Plug>(vimfiler_new_file)
autocmd FileType vimfiler nmap <buffer> o <Plug>(vimfiler_cd_or_edit)
autocmd FileType vimfiler nmap <buffer> l <Plug>(vimfiler_smart_l)
autocmd FileType vimfiler nmap <buffer> h <Plug>(vimfiler_smart_h)
autocmd FileType vimfiler nmap <buffer> q <Plug>(vimfiler_hide)
autocmd FileType vimfiler nmap <buffer> Q <Plug>(vimfiler_exit)
autocmd FileType vimfiler nmap <buffer> , <Plug>(vimfiler_toggle_mark_current_line)
autocmd FileType vimfiler nmap <buffer> v <Plug>(vimfiler_split_edit_file)

autocmd FileType vimfiler nnoremap <silent><buffer><expr> s vimfiler#do_switch_action('split')
autocmd FileType vimfiler nnoremap <silent><buffer><expr> t vimfiler#do_switch_action('tabopen')

autocmd FileType vimfiler nmap <buffer> S <Plug>(easymotion-overwin-f2)


"vim-easymotion
let g:EasyMotion_do_mapping = 0


"indentLine
let g:indentLine_faster = 1
let g:indentLine_char = "│"


"emmet
let g:user_emmet_leader_key = '<C-m>'


"general
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

command! Config source ~/.vimrc

syntax enable
colorscheme solarized
highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE

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


"maps
let mapleader = "\<Space>"

nmap s <Plug>(easymotion-overwin-f2)
nmap S <Plug>(easymotion-overwin-f2)
noremap <S-h> ^
noremap <S-j> }
noremap <S-k> {
noremap <S-l> $
nnoremap q :q<CR>
nnoremap <Leader>s :%s/
nnoremap <Leader><Space> :w<CR>
nnoremap <Leader>n :noh<CR>
nnoremap <Leader>t :tabnew<CR>
nnoremap <Leader>e :VimFilerExplorer -winwidth=30<CR>
nnoremap <Leader>f :VimFiler -horizontal<CR>
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
nnoremap x "_x
nnoremap ; :
nnoremap : ;
nnoremap j gj
nnoremap k gk
nnoremap Y y$
