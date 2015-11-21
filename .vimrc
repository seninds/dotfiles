set nocompatible

set exrc  " Allow per-directory vimrc
set secure

set relativenumber
set number
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

set nowrap  " Turn of text wrapping

set expandtab  " Automatically expand tabs into spaces
set shiftwidth=4 softtabstop=4 tabstop=4

filetype indent on
set autoindent

" Turn of swap files and backups
set nobackup
set noswapfile
set nowritebackup

set ruler  " Display position coordinates in bottom right

set hlsearch  " hightlight search pattern
set incsearch  " show the next match while entering a search
set nowrapscan
nnoremap <silent> <C-l> :nohl<CR><C-l>

set fileencodings=utf-8,cp1251,koi8-r
set encoding=utf-8

" Ctrl-j/k deletes blank line below/above, and Alt-j/k inserts.
nnoremap <silent> <C-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent> <C-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent> j :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent> k :set paste<CR>m`O<Esc>``:set nopaste<CR>

syntax enable
set background=dark
colorscheme elflord

if exists('+colorcolumn')
      set colorcolumn=80
endif

augroup vimrc
" Automatically delete trailing DOS-returns and whitespace on file open and write.
  autocmd BufRead,BufWritePre,FileWritePre * silent! %s/[\r \t]\+$//
augroup END
