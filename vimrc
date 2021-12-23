" plugins
call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'
" Required for vim-airline to show the branch name.
Plug 'tpope/vim-fugitive'
Plug 'jiangmiao/auto-pairs'
Plug 'sheerun/vim-polyglot'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries'  }
Plug 'vim-ruby/vim-ruby'
Plug 'dracula/vim', { 'as': 'dracula' }

call plug#end()

" Trying out Dracula.
colorscheme dracula

" config plugins
"nnoremap ;o :NERDTreeToggle .<CR>
"nnoremap ;l :call NERDComment("n", "Toggle")<CR>
"nnoremap <C-/> :call NERDComment("n", "Toggle")<CR>
"vnoremap <C-/> :call NERDComment("n", "Toggle")<CR>
"/plugins

nnoremap ;s :shell<CR>
" Add the current filename and line number to the active tmux notes buffer.
nnoremap ;n :execute ":!echo %:".line('.')." \| anote"<CR><CR>
" Add the current highlight to the active tmux notes buffer.
vnoremap ;n :'<,'>!anote<CR><CR>u
" Execute current line
nnoremap ;1 :.!zsh<CR>
" Write with capital or lowercase w.
command! W :w

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

" Use the system clipboard for yank/paste.
set clipboard=unnamed

