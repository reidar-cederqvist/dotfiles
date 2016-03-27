" Type :so % to refresh .vimrc after making changes

"Use vim settings rather than vi settings early for no side effects.
set nocompatible
" Map leader to spacbar
let mapleader = " "
" Map jj to esc  
ino jj <esc>
vno v <esc>
"enable syntax colors
syntax on
"enable pathogen
execute pathogen#infect()
"insert ▸ + the rest spaces for tab and - for traling whitespaces
set listchars=tab:▸\ ,eol:¬,trail:-
"fix searches
set gdefault
set ignorecase
set showmatch
set smartcase
"Make it obvious where 100 char is
set textwidth=100
set formatoptions=qrn1
set wrapmargin=0
set colorcolumn=+1
"split to right and bottom
set splitright
"HTML Editing
set matchpairs+=<:>
" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'
"make search go directly to match
set incsearch
"display numbers at the left of the screen
"and toggle to relative in normal mode
set number
set rnu
function! ToggleNumbersOn()
    set nu!
    set rnu
endfunction
function! ToggleRelativeOn()
    set rnu!
    set nu
endfunction
autocmd FocusLost * call ToggleRelativeOn()
autocmd FocusGained * call ToggleRelativeOn()
autocmd InsertEnter * call ToggleRelativeOn()
autocmd InsertLeave * call ToggleRelativeOn()
"show cursor position always
set ruler
set showcmd			"display incomplete command
set laststatus=2	"Always display the status line
set autowrite		" Automatically :write before running commands
set autoread		" Reload files changed outside vim
" Trigger autoread when changing buffers or coming back to vim in terminal.
au FocusGained,BufEnter * :silent! !
"set the taab and eol chars to blue
highlight Normal ctermbg=none
highlight SpecialKey ctermfg=4
highlight NonText ctermfg=4
highlight LineNr ctermfg=244
set visualbell "stop beeping
"enable mouse
set mouse=a
set list
set tabstop=4
set shiftwidth=4
set autoindent
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeWinSize = 50
set ww=l,h,b,s,<,>,[,]
nnoremap WQ wq
nnoremap Wq wq
nnoremap W w
nnoremap Q q
noremap <C-J> <C-w>j
noremap <C-L> <C-w>l
noremap <C-K> <C-w>k
noremap <C-H> <C-w>h
nnoremap <CR> o<Esc>
" ================ Scrolling ========================
set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1
" Use tab to jump between blocks, because it's easier
nnoremap <tab> %
vnoremap <tab> %
""" SYSTEM CLIPBOARD COPY & PASTE SUPPORT
set pastetoggle=<F2> "F2 before pasting to preserve indentation
nnoremap <leader>q @q
" Quickly close windows
nnoremap <leader>x :x<cr>
nnoremap <leader>X :q!<cr>
" When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
    " inside an event handler (happens when dropping a file on gvim).
autocmd BufReadPost *
	\ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
	\   exe "normal g`\"" |
	\ endif
inoremap <Esc> wrong try again
