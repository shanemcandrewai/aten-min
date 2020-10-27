"Last change set shiftwidth=2
source $VIMRUNTIME/defaults.vim
set showmode
set ignorecase
set smartcase "Override ignorecase option if the search contains upper case
set linebreak 
set encoding=utf-8
set noswapfile
"set shiftwidth=2
inoremap jj <Esc>
inoremap <C-S> <Esc>:w<CR>
nnoremap ; :

let mapleader = "\<Space>"

nnoremap <Leader>a a_<Esc>r
nnoremap <Leader>b ^
nnoremap <Leader>d :edit %:p:h<CR>
nnoremap <Leader>e $
nnoremap <Leader>f <C-]>
nnoremap <Leader>i i_<Esc>r
nnoremap <Leader>r @:
nnoremap <Leader>s :source %<CR>
nnoremap <Leader>t :put =strftime('%c')<CR>
nnoremap <Leader>v :edit $MYVIMRC<CR>

"nnoremap <Leader>n :set columns=80<CR>
"nnoremap <Leader>w :set columns=160<CR>
":put =expand('%')   insert current file name
