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
Plug 'dense-analysis/ale'

call plug#end()

" config plugins
"nnoremap ;o :NERDTreeToggle .<CR>
"nnoremap ;l :call NERDComment("n", "Toggle")<CR>
"nnoremap <C-/> :call NERDComment("n", "Toggle")<CR>
"vnoremap <C-/> :call NERDComment("n", "Toggle")<CR>
" /plugins

nnoremap ;s :shell<CR>
" Add the current filename and line number to the active tmux notes buffer.
nnoremap ;n :silent execute ":!echo %:".line('.')." \| n.add"<CR>
" Add the current highlight to the active tmux notes buffer.
vnoremap ;n :'<,'>!n.add<CR>u

" Execute current line
nnoremap ;1 :.!zsh<CR>
" Write with capital or lowercase w.
command! W :w
command! Wq :wq
" Get current branch from git.
nnoremap ;b :execute 'norm i' . system("git.branch")<CR><Esc>kJa
" Reload vimrc.
nnoremap ;rr :so ~/.vimrc<CR>
nnoremap ;rn :set rnu!<CR>

set grepprg=rg\ --vimgrep\ -i
autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
autocmd BufRead,BufNewFile $NOTES_PATH* setlocal path+=$NOTES_PATH/**
autocmd BufRead,BufNewFile $BLOG_PATH* setlocal path+=$BLOG_PATH/**
set suffixesadd+=.md
nnoremap ;t gf
nnoremap ;f :!find . -iname \*<cword>\* \| menu<CR>
nnoremap ;g :silent execute "grep! " . shellescape(expand("<cword>"))<CR>:copen<CR>

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
colorscheme peachpuff

" Spell good in markdown!
autocmd BufNewFile,BufRead *.md setlocal spell spelllang=en_us

" Numbers
set number
set numberwidth=5

" Maps `jj` to escape.
imap jj <Esc>

set autoindent smartindent

" Use the system clipboard for yank/paste.
set clipboard=unnamed

" start at last place you were editing
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Lint with ALE / Rubocop
" Set specific linters
let g:ale_linters = { 'ruby': ['rubocop'] }
let g:ale_linters_explicit = 1
let g:airline#extensions#ale#enabled = 1
let g:ale_sign_column_always = 1
" Disable ALE auto highlights
let g:ale_set_highlights = 0
nnoremap ;rc :execute ":!rubocop -A %"<CR>
