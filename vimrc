colorscheme default
syntax on
execute pathogen#infect()
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
set listchars=tab:▸\ ,eol:¬
set ignorecase
set smartcase
set incsearch
set list
set tabstop=4
set shiftwidth=4
set autoindent
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeWinSize = 50
set mouse=a
set ww=l,h,b,s,<,>,[,]
