syntax on
execute pathogen#infect()
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
set tabstop=4
set shiftwidth=4
set autoindent
map <C-n> :NERDTreeToggle<CR>
colorscheme evening
let g:NERDTreeWinSize = 40
set mouse=a
set ww=l,h,b,s,<,>,[,]
