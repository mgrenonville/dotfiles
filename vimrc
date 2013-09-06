
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

Bundle 'Lokaltog/vim-easymotion'


filetype plugin indent on     " required!
syn on 
set relativenumber
" always display status-line
set laststatus=2
set background=dark
colorscheme Tomorrow-Night-Eighties



