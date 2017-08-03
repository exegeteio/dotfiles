call plug#begin('~/.vim/plugged')

Plug 'altercation/vim-colors-solarized'
Plug 'endel/vim-github-colorscheme'
Plug 'tpope/vim-fugitive'
" Plug 'bling/vim-airline'

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'ctrlpvim/ctrlp.vim'

Plug 'jiangmiao/auto-pairs'
Plug 'vim-scripts/HTML-AutoCloseTag'

call plug#end()

nnoremap ;o :NERDTreeToggle .<CR>
nnoremap ;s :shell<CR>

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
