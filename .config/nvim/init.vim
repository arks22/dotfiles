"init.vim is configuration file for 'NeoVim'.

""""""""dein.vim""""""""
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
  call dein#load_toml('~/.config/nvim/dein.toml',{'lazy':0})
  call dein#load_toml('~/.config/nvim/dein_lazy.toml', {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif

if dein#check_install(['vimproc'])
  call dein#install(['vimproc'])
endif

if dein#check_install()
  call dein#install()
endif
"! Note:  excute dein#update when you update plugin list

"colorscheme
set background=dark
colorscheme NeoSolarized
syntax on
highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE

highlight Defx_filename_directory ctermfg=004
highlight Defx_filename_root ctermfg=006
highlight DefxIconsOpenedTreeIcon ctermfg=006


"call map(dein#check_clean(), "delete(v:val, 'rf')")

""""""""deoplete""""""""
let g:deoplete#enable_at_startup = 1


""""""""defx.nvim""""""""
autocmd VimEnter * execute 'Defx'

""""""""vimtex""""""""
let g:vimtex_quickfix_mode=0
let g:vimtex_view_method='skim'

"update defx status automatically when changing file
autocmd BufEnter * call defx#redraw() 
autocmd BufWritePost * call defx#redraw() 

call defx#custom#option('_', {
  \ 'winwidth': 40,
  \ 'split': 'vertical',
  \ 'direction': 'topleft',
  \ 'show_ignored_files': 1,
  \ 'buffer_name': 'explorer',
  \ 'toggle': 0,
  \ 'resume': 1,
  \ 'columns': 'indent:git:icons:space:filename:mark',
  \ 'root_marker':' [In]:'
  \ })

call defx#custom#column('mark', {
  \ 'readonly_icon': '',
  \ })


call defx#custom#column('git', 'indicators', {
  \ 'Modified'  : '✹',
  \ 'Staged'    : '✚',
  \ 'Untracked' : '✭',
  \ 'Renamed'   : '➜',
  \ 'Unmerged'  : '═',
  \ 'Ignored'   : '☒',
  \ 'Deleted'   : '✖',
  \ 'Unknown'   : '?'
  \ })

let g:defx_icons_enable_syntax_highlight = 1
let g:defx_icons_column_length = 1
let g:defx_icons_directory_icon = ''
let g:defx_icons_mark_icon = '*'
let g:defx_icons_copy_icon = ''
let g:defx_icons_link_icon = ''
let g:defx_icons_move_icon = ''
let g:defx_icons_parent_icon = ''
let g:defx_icons_default_icon = ''
let g:defx_icons_directory_symlink_icon = ''
let g:defx_icons_root_opened_tree_icon = ''
let g:defx_icons_nested_opened_tree_icon = ''
let g:defx_icons_nested_closed_tree_icon = ''


"mapping
autocmd FileType defx call s:defx_my_settings()

function! s:defx_my_settings() abort
  nnoremap <silent><buffer><expr> <CR> defx#do_action('drop')
  nnoremap <silent><buffer><expr> c defx#do_action('copy')
  nnoremap <silent><buffer><expr> m defx#do_action('move')
  nnoremap <silent><buffer><expr> p defx#do_action('paste')
  nnoremap <silent><buffer><expr> l defx#do_action('drop')
  nnoremap <silent><buffer><expr> t defx#do_action('open','tabnew')
  nnoremap <silent><buffer><expr> E defx#do_action('drop', 'vsplit')
  nnoremap <silent><buffer><expr> P defx#do_action('drop', 'pedit')
  nnoremap <silent><buffer><expr> o defx#do_action('open_or_close_tree')
  nnoremap <silent><buffer><expr> K defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N defx#do_action('new_file')
  nnoremap <silent><buffer><expr> M defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> S defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> d defx#do_action('remove')
  nnoremap <silent><buffer><expr> r defx#do_action('rename')
  nnoremap <silent><buffer><expr> ! defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> . defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> ; defx#do_action('repeat')
  nnoremap <silent><buffer><expr> h defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q defx#do_action('quit')
  nnoremap <silent><buffer><expr> s defx#do_action('toggle_select')
  nnoremap <silent><buffer><expr> * defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-g> defx#do_action('print')
  nnoremap <silent><buffer><expr> cd defx#do_action('change_vim_cwd')
endfunction


"terminal
set sh=zsh


"filetype plugin indent on


"lightline
let g:lightline = {
  \ 'colorscheme': 'solarized',
  \ 'component_function': {
  \   'filename': 'LightLineFileNameWithParentDir'
  \ }
  \ }

function! LightLineFileNameWithParentDir()
  if expand('%:t') ==# ''
      let filename = '[No Name]'
  else
      let dirfiles = split(expand('%:p'), '/')
      if len(dirfiles) < 2
          let filename = dirfiles[0]
      else
          let filename = dirfiles[-2] . '/' . dirfiles[-1]
      endif
  endif
  return filename
endfunction


function! LightlineTabFilename(n) abort
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let _ = pathshorten(expand('#'.buflist[winnr - 1].':f'))
  return _ !=# '' ? _ : '[No Name]'
endfunction


"winresizer
let g:winresizer_vert_resize = 3
let g:winresizer_start_key = '<Leader>r'


"general
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

"python PATH
let g:python_host_prog  = system('echo -n $(which python2)')
let g:python3_host_prog = system('echo -n $(which python3)')



set statusline=
set clipboard=unnamed
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
set smartindent
set splitbelow
set splitright
set modifiable


""""""""maps""""""""
let mapleader = "\<Space>"

command! Reload source ~/.config/nvim/init.vim

noremap <S-h> ^
noremap <S-j> }
noremap <S-k> {
noremap <S-l> $
nnoremap q :q<CR>
"nnoremap <Leader>o\ :<C-u>Deol -split=vertical<CR>
"nnoremap <Leader>o- :<C-u>Deol -split=otherwise<CR>
"nnoremap <Leader>of :<C-u>Deol -split=floating<CR>
"nnoremap <Leader>oo :<C-u>tabnew<CR>:Deol<CR>
nnoremap <Leader>t\ :<C-u>vertical split<CR>:terminal<CR>
nnoremap <Leader>t- :<C-u>split<CR>:terminal<CR>
nnoremap <Leader>tt :<C-u>tabnew<CR>:terminal<CR>
nnoremap <Leader>f :<C-u>Defx -new<CR>
nnoremap <Leader><Space> :w<CR>
nnoremap <Leader>n :noh<CR>
nnoremap <Leader>t :tabnew<CR>
nnoremap <Leader>j <C-w>j
nnoremap <Leader>k <C-w>k
nnoremap <Leader>l <C-w>l
nnoremap <Leader>h <C-w>h
nnoremap <Leader>- :new<CR>
nnoremap <Leader>\ :vertical new<CR>
nnoremap <Leader>d "_d
nnoremap <Leader>D "_D
nnoremap x "_x
nnoremap ; :
nnoremap : ;
nnoremap j gj
nnoremap k gk
nnoremap Y y$
nnoremap <C-l> gt
nnoremap <C-h> gT


"insert mode maps
inoremap <silent> jj <ESC>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

"terminal mode maps
tnoremap <C-[> <C-\><C-n>
tnoremap <C-l> <C-\><C-n>gt
tnoremap <C-h> <C-\><C-n>gT
