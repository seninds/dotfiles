set nocompatible

set exrc  " Allow per-directory vimrc
set secure

set number
set relativenumber

set nowrap  " Turn of text wrapping
set tabstop=4 shiftwidth=4 softtabstop=4 expandtab

filetype off
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on
syntax on

set smartindent

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

set background=dark
colorscheme elflord
hi TabLineFill ctermfg=DarkGray ctermbg=Black

if exists('+colorcolumn')
    set colorcolumn=80
endif

set foldenable
set foldmethod=manual
set foldcolumn=5

augroup vimrc
    " Automatically delete trailing DOS-returns and whitespace
    autocmd BufRead,BufWritePre,FileWritePre * silent! %s/[\r \t]\+$//
augroup END

set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan
