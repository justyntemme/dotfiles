highlight Pmenu ctermfg=15 ctermbg=0 guifg=#ffffff guibg=#000000
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
set autowrite
filetype plugin on
set backspace=indent,eol,start
" Enable autocompletion
" set omnifunc=syntaxcomplete#Complete
" " Select keyword as you type
" :set completeopt=longest,menuone
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1

" Auto formatting and importing
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"
autocmd VimEnter * NERDTree | wincmd p
syntax on
nmap <F6> :NERDTreeToggle<CR>
" REplace gofmt with goimports
let g:go_fmt_command = "goimports"
let g:NERDTreeWinPos = "right"
let g:NERDTreeWinSize = 25
set bg=dark
set hidden
let g:go_highlight_structs = 1 
let g:go_highlight_methods = 1
let g:go_highlight_functions = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
:set syntax=on
:set filetype=go
