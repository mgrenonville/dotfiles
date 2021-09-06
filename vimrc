
set nocompatible               " be iMproved
filetype off                   " required!
execute pathogen#infect()

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()


" let Vundle manage Vundle
" required! 
Plugin 'VundleVim/Vundle.vim'

Plugin 'vim-airline/vim-airline'

" git tools
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" File navigation
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'kien/ctrlp.vim'
Plugin 'Lokaltog/vim-easymotion'

" Themes
Plugin 'chriskempson/base16-vim'

" Editing facilities
" Multiple cursor 
" Uses Ctrl + N
Plugin 'terryma/vim-multiple-cursors'
" Autoclose ", ', (, ...
Plugin 'Raimondi/delimitMate'

" Supertab
Plugin 'ervandew/supertab'

Plugin 'derekwyatt/vim-scala'

Plugin 'Rykka/riv.vim'

" Markdown
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

" Javascript IDE

Plugin 'jelera/vim-javascript-syntax'
Plugin 'pangloss/vim-javascript'
Plugin 'scrooloose/syntastic'

Plugin 'jparise/vim-graphql'

call vundle#end()            " required
filetype plugin indent on     " required!

syn on 
set relativenumber
" always display status-line
set laststatus=2
set background=dark

let base16colorspace=256  " Access colors present in 256 colorspace"
colorscheme base16-default-dark 
" Other them. Might be better"
" colorscheme Tomorrow-Night-Eighties


" Add smart completion of command 
set wildmenu
set cmdheight=2

let g:airline#extensions#tabline#enabled = 1
let g:vim_markdown_folding_disabled=1

" Toggle NERDTree on F12
map <F12> :NERDTreeToggle <CR>


" One of the most important options to activate. Allows you to switch from an
" " unsaved buffer without saving it first. Also allows you to keep an undo
" " history for multiple files. Vim will complain if you try to quit without
" " saving, and swap files will keep you safe if your computer crashes.
 set hidden
"set autochdir
set showmatch
set autowrite
"
set undodir=~/.vim/tmp/undo//     " undo files
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files
set backup                        " enable backups
set undofile                      " enable undo files
set showcmd

set tabstop=4
set smartindent
set shiftwidth=4
set expandtab

set ttyfast
set scrolloff=3
set sidescrolloff=3


autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 expandtab

autocmd VimResized * wincmd =

map <F4> :NERDTreeFind <CR>  
nnoremap <A-left> :bN <CR> 
nnoremap <A-right> :bn <CR> 


cmap w!! w !sudo tee % >/dev/null

