syntax on

set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch

set colorcolumn=80

call plug#begin('~/.vim/plugged')
    Plug 'morhetz/gruvbox'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'fatih/vim-go'
    Plug 'mbbill/undotree'
    Plug 'Shougo/neocomplete'
    Plug 'majutsushi/tagbar'
    
call plug#end()

colorscheme gruvbox
set background=dark

if executable('rg')
    let g:rg_derive_root='true'
endif

let mapleader = " "
let g:netrw_browse_split=2

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j <CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>pv :wincmd v<var> :Ex <bar> :ve resize 30<CR>
nnoremap <Leader>ps :Rg<SPACE>

nnoremap <silent> <Leader>gd :YcmCompleter GTo<CR>
nnoremap <silent> <Leader>gf :YcmCompleter FixIt<CR>

