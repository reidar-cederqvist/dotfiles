" Type :so % to refresh .vimrc after making changes
set nocompatible              " be iMproved, required

"################# AUTOCMD #######################
if !exists("autocommands_loaded")
	let autocommands_loaded = 1
	autocmd!
	" Highlight lines over 80 chars
	autocmd BufWinEnter *.c,*.h let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
	" Trigger autoread when changing buffers or coming back to vim in terminal.
	autocmd FocusGained,BufEnter * :silent! !
	autocmd FocusLost * call ToggleRelativeOn()
	autocmd FocusGained * call ToggleRelativeOn()
	autocmd InsertEnter * call ToggleRelativeOn()
	autocmd InsertLeave * call ToggleRelativeOn()
	" When editing a file, always jump to the last known cursor position.
	" Don't do it for commit messages, when the position is invalid, or when
	" inside an event handler (happens when dropping a file on gvim).
	autocmd BufReadPost *
		\ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
		\   exe "normal g'\"" |
		\ endif
	" open nerdtree when no argument was given
	autocmd StdinReadPre * let s:std_in=1
	autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
endif
"################## END AUTOCMD #########################

" set the runtime path to include Vundle and initialize
" set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
call plug#begin('~/.vim/plugged')

" plugin on GitHub repo
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'dylanaraps/wal.vim'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'christoomey/vim-system-copy'
Plug 'ap/vim-css-color'
" Plug 'valloric/youcompleteme'
" Plug 'SirVer/ultisnips'
Plug 'scrooloose/nerdtree'

" All of your Plug must be added before the following line
call plug#end()
" ==== end of vim-plug  ============== "

filetype plugin indent on
" enable finding files in sub-directories with find
set path+=**
set wildmenu
set hls
set title
set laststatus=2
set encoding=utf-8
colorscheme wal
set t_Co=256
" Map leader to spacbar
let mapleader = " "
" Map jj to esc
ino jj <Esc>
vno v <esc>
"enable syntax colors
syntax on
"insert ▸ + the rest spaces for tab and - for traling whitespaces
set listchars=tab:\ \ ,eol:¬,trail:-
"fix searches
set hls
set gdefault
set ignorecase
set showmatch
set smartcase
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

"show cursor position always
set ruler
set showcmd			"display incomplete command
set laststatus=2	"Always display the status line
set autowrite		" Automatically :write before running commands
set autoread		" Reload files changed outside vim
"set the taab and eol chars to blue
highlight Normal ctermbg=none
highlight SpecialKey ctermfg=4
highlight NonText ctermfg=4
highlight LineNr ctermfg=244
set visualbell "stop beeping
"enable mouse
set mouse=a
set list
set tabstop=8
set shiftwidth=8
set autoindent
map <leader>n :NERDTreeToggle<CR>
let g:NERDTreeWinSize = 50
set ww=l,h,b,s,<,>,[,]
noremap <C-J> <C-w>j
noremap <C-L> <C-w>l
noremap <C-K> <C-w>k
noremap <C-H> <C-w>h
" ================ Scrolling ========================
set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1
""" SYSTEM CLIPBOARD COPY & PASTE SUPPORT
set pastetoggle=<F2> "F2 before pasting to preserve indentation
nnoremap <leader>q @q
nnoremap <leader>f @f
nnoremap <leader>w @w
nnoremap <leader>e @e
nnoremap & $%
" Quickly close windows
nnoremap <leader>x :x<cr>
nnoremap <leader>X :q!<cr>
nnoremap <leader>kd :w<cr>:make debug<cr><cr><cr>
" fixe so that you can use = to fix indentation to 4-space taab
" set shiftwidth=4
" set tabstop=4
" remove whitespace inside comment
" let b:commentary_format ='/*%s*/'
autocmd FileType json set commentstring=//%s tabstop=2 shiftwidth=2 expandtab
set ttymouse=sgr
