" Type :so % to refresh .vimrc after making changes
set nocompatible              " be iMproved, required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'vim-scripts/ReplaceWithRegister'
Plugin 'christoomey/vim-system-copy'
" Plugin 'valloric/youcompleteme'
" Plugin 'SirVer/ultisnips'
Plugin 'scrooloose/nerdtree'
" Plugin 'easymotion/vim-easymotion'
" Plugin 'Lokaltog/vim-powerline'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()
" ==== end of vundle ============== "

" ========== Ultisnips ============ "
" " Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
" let g:UltiSnipsExpandTrigger = "<c-e>"
" let g:UltiSnipsSnippetsDir = "~/.vim/bundle/ultisnips/UltiSnips"
" let g:UltiSnipsJumpForwardTrigger="<c-f>"
" let g:UltiSnipsJumpBackwardTrigger="<c-b>"

" " If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"
" ======== end Ultisnips ========== "
filetype plugin indent on
" enable finding files in sub-directories with find
set path+=**
set wildmenu
set hls
set laststatus=2
set encoding=utf-8
set t_Co=256
" Map leader to spacbar
let mapleader = " "
" Map jj to esc
ino jj <Esc>
vno v <esc>
" Highlight lines over 80 chars
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/
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
" When editing a file, always jump to the last known cursor position.
" Don't do it for commit messages, when the position is invalid, or when
" inside an event handler (happens when dropping a file on gvim).
autocmd BufReadPost *
	\ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
	\   exe "normal g`\"" |
	\ endif
" open nerdtree when no argument was given
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" fixe so that you can use = to fix indentation to 4-space taab
" set shiftwidth=4
" set tabstop=4
" remove whitespace inside comment
" let b:commentary_format ='/*%s*/'
