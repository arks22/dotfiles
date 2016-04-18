let g:user_emmet_leader_key='<c-m>'
let g:indentLine_faster=1
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

syntax enable
map <C-l> gt
map <C-h> gT
nmap <silent><Leader>i :<C-u>IndentLinesToggle<CR>
colorscheme solarized 
set background=dark
set number
set noswapfile
set expandtab
set tabstop=2
set shiftwidth=2
set hlsearch
set nowrap
set vb t_vb= "beepを鳴らさない
set backspace=indent,eol,start "インサートモードでバックスペースが効かない時の設定


"キーマップの設定
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


"Dein.vimの設定
if &compatible
  set nocompatible
endif
set runtimepath^=~/.vim/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.cache/dein'))

call dein#add('/Users/arks22/.vim/repos/github.com/Shougo/dein.vim')
call dein#add('Shougo/neocomplete.vim')
call dein#add('Shougo/unite.vim')
call dein#add('Shougo/vimfiler')
call dein#add('scrooloose/nerdtree')
call dein#add('mattn/emmet-vim')
call dein#add('Yggdroot/indentLine')
call dein#add('w0ng/vim-hybrid')

call dein#end()

filetype plugin indent on
