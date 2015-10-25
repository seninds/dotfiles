set nocompatible

set exrc  " Allow per-directory vimrc
set secure

set relativenumber
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

set nowrap  " Turn of text wrapping

set expandtab  " Automatically expand tabs into spaces
set shiftwidth=4 softtabstop=4 tabstop=4
autocmd FileType cpp setlocal shiftwidth=2 softtabstop=2 tabstop=2
autocmd FileType c setlocal shiftwidth=2 softtabstop=2 tabstop=2

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
