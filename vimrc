" plugins
call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'
" Required for vim-airline to show the branch name.
Plug 'tpope/vim-fugitive'
" Plug 'jiangmiao/auto-pairs'
Plug 'sheerun/vim-polyglot'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries'  }
Plug 'vim-ruby/vim-ruby'
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf'
Plug 'ecomba/vim-ruby-refactoring'
Plug 'adelarsq/vim-matchit'

call plug#end()

let mapleader = ";"
" config plugins
"nnoremap <Leader>o :NERDTreeToggle .<CR>
nnoremap <Leader>o :FZF<CR>
"nnoremap <Leader>l :call NERDComment("n", "Toggle")<CR>
"nnoremap <C-/> :call NERDComment("n", "Toggle")<CR>
"vnoremap <C-/> :call NERDComment("n", "Toggle")<CR>
" /plugins

nnoremap <Leader>s :shell<CR>
" Add the current filename and line number to the active tmux notes buffer.
nnoremap <Leader>n :silent execute ":!echo %:".line('.')." \| n.add"<CR>
nnoremap <Leader>nl :silent execute ":!echo %:".line('.')." \| pbcopy"<CR>
" Add the current highlight to the active tmux notes buffer.
vnoremap <Leader>n :'<,'>!n.add<CR>u

" Execute current line
nnoremap <Leader>1 :.!zsh<CR>
" Write with capital or lowercase w.
command! W :w
command! Wq :wq
" Get current branch from git.
nnoremap <Leader>b :execute 'norm i' . system("g.branch")<CR><Esc>kJa
" Reload vimrc.
nnoremap <Leader>rr :so ~/.vimrc<CR>
nnoremap <Leader>rn :set rnu!<CR>
nnoremap <Leader>rs :set spell!<CR>

set grepprg=rg\ --vimgrep\ -i
autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
autocmd BufRead,BufNewFile $NOTES_PATH* setlocal path+=$NOTES_PATH/**
autocmd BufRead,BufNewFile $BLOG_PATH* setlocal path+=$BLOG_PATH/**
autocmd BufNewFile,BufRead $NOTES_PATH* setlocal nonu nornu
set suffixesadd+=.md
nnoremap <Leader>t gf
nnoremap <Leader>f :!find . -iname \*<cword>\* \| menu<CR>
nnoremap <Leader>g :silent execute "grep! " . shellescape(expand("<cword>"))<CR>:copen<CR>
" Fix Y in neovim:
nnoremap Y yy

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
colorscheme elflord

" Spell good in markdown!
autocmd BufNewFile,BufRead *.md setlocal spell spelllang=en_us

" Numbers
" set number
" TODO - Do I like this?
" set nu rnu
set numberwidth=3

" Maps `jj` to escape.
imap jj <Esc>

set autoindent smartindent

" Use the system clipboard for yank/paste.
set clipboard=unnamed

" start at last place you were editing
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Lint with ALE / Rubocop
" Set specific linters
let g:ale_linters = { 'ruby': ['standardrb'] }
let g:ale_linters_explicit = 1
let g:airline#extensions#ale#enabled = 1
let g:ale_sign_column_always = 1
" Disable ALE auto highlights
let g:ale_set_highlights = 0
nnoremap <Leader>rc :execute ":!be rubocop -a %"<CR>
