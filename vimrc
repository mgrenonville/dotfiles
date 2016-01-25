
set nocompatible               " be iMproved
filetype off                   " required!
execute pathogen#infect()

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()


" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

Bundle 'bling/vim-airline'

" git tools
Bundle 'tpope/vim-fugitive'
Bundle 'airblade/vim-gitgutter'

" File navigation
Bundle 'scrooloose/nerdtree'
Bundle 'kien/ctrlp.vim'
Bundle 'Lokaltog/vim-easymotion'

" Editing facilities
" Multiple cursor 
" Uses Ctrl + N
Bundle 'terryma/vim-multiple-cursors'
" Autoclose ", ', (, ...
Bundle 'Raimondi/delimitMate'

" Supertab
Bundle 'ervandew/supertab'

Bundle 'derekwyatt/vim-scala'

Bundle 'Rykka/riv.vim'

" Markdown
Bundle 'godlygeek/tabular'
Bundle 'plasticboy/vim-markdown'

" Javascript IDE

Bundle 'jelera/vim-javascript-syntax'
Bundle 'pangloss/vim-javascript'
Bundle 'scrooloose/syntastic'



filetype plugin indent on     " required!
syn on 
set relativenumber
" always display status-line
set laststatus=2
set background=dark

colorscheme Tomorrow-Night 
" Other them. Might be better"
" colorscheme Tomorrow-Night-Eighties


" Add smart completion of command 
set wildmenu

let g:airline#extensions#tabline#enabled = 1
let g:vim_markdown_folding_disabled=1

" Toggle NERDTree on F12
map <F12> :NERDTreeToggle <CR>


set tabstop=4
set smartindent
set shiftwidth=4
set expandtab

autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 expandtab

map <F4> :NERDTreeFind <CR>  
nnoremap <A-left> :bN <CR> 
nnoremap <A-right> :bn <CR> 

