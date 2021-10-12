call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'
Plug 'endel/vim-github-colorscheme'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-scripts/HTML-AutoCloseTag'
Plug 'sheerun/vim-polyglot'

call plug#end()

nnoremap ;o :NERDTreeToggle .<CR>
nnoremap ;s :shell<CR>
nnoremap ;l :call NERDComment("n", "Toggle")<CR>
nnoremap <C-/> :call NERDComment("n", "Toggle")<CR>
vnoremap <C-/> :call NERDComment("n", "Toggle")<CR>

" Soft tabs
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

set cursorline    " highlight the current line"

" Make it obvious where 100 characters is
set textwidth=100
" set formatoptions=cq
set formatoptions=qrn1
set wrapmargin=0
set colorcolumn=+1

" Numbers
set number
set numberwidth=5

" Maps `jj` to escape.
imap jj <Esc>

set autoindent smartindent
