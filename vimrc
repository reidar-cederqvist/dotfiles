syntax on
execute pathogen#infect()
autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
set tabstop=4
set shiftwidth=4
set autoindent
map <C-n> :NERDTreeToggle<CR>
function! MakeSession()
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  if (filewritable(b:sessiondir) != 2)
    exe 'silent !mkdir -p ' b:sessiondir
    redraw!
  endif
  let b:filename = b:sessiondir . '/session.vim'
  exe "mksession! " . b:filename
endfunction

function! LoadSession()
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  let b:sessionfile = b:sessiondir . "/session.vim"
  if (filereadable(b:sessionfile))
    exe 'source ' b:sessionfile
  else
    echo "No session loaded."
  endif
endfunction

" Adding automatons for when entering or leaving Vim
au VimEnter * if argc() == 0 | nested :call LoadSession() | endif
au VimLeave * :call MakeSession()
" autocmd BufWinLeave * :call MakeSession()
" autocmd BufWinEnter * :call LoadSession()
autocmd BufWinLeave *.* mkview!
autocmd BufWinEnter *.* silent loadview
colorscheme desert
let g:NERDTreeWinSize = 40
