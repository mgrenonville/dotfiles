dotfiles
========


# INSTALLATION
* Install pathogen to `~/.vim/autoload/pathogen.vim`.  Or copy and paste:

    $ mkdir -p ~/.vim/autoload ~/.vim/bundle; \
    $ curl -Sso ~/.vim/autoload/pathogen.vim \
        https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

* Install Vundle 
    $ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

* Link vimrc file in home 
    $ ln -sv ~/dotfiles/vimrc ~/.vimrc

* Install tomorrow-theme
    $ git clone https://github.com/chriskempson/tomorrow-theme.git /tmp/tomorrow-theme
    $ mkdir -p  ~/.vim/bundle/tomorrow-theme
    $ cp -a /tmp/tomorrow-theme/vim/colors/ ~/.vim/bundle/tomorrow-theme

* Launch vim and type :BundleInstall



