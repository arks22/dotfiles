if has('vim_starting')
   set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'Yggdroot/indentLine'
NeoBundle 'w0ng/vim-hybrid'
let g:user_emmet_leader_key='<c-m>'
let g:indentLine_faster = 1
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"
syntax enable
map <C-l> gt
map <C-h> gT
nmap <silent><Leader>i :<C-u>IndentLinesToggle<CR>
set background=dark
colorscheme solarized 
set number
set noswapfile
set expandtab
set tabstop=2
set shiftwidth=2
set hlsearch
set nowrap
call neobundle#end()
filetype plugin indent on
nnoremap s <Nop>
nnoremap <silent><C-e> :NERDTree<CR>
nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap s< <C-w>>
nnoremap s> <C-w><
nnoremap s+ <C-w>+
nnoremap s- <C-w>-
NeoBundleCheck
