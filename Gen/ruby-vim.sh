#!/bin/bash
# make VIM your ruby/rails IDE mostly by following Tim Pope
plugins="vim-speeddating vim-haml vim-cucumber vim-vividchalk vim-endwise vim-surround vim-unimpaired vim-repeat vim-abolish vim-rails vim-pathogen"
#plugins="speeddating git haml abolish rails"
BASE_DIR=$HOME/tpope-vim
if [ ! -d $BASE_DIR ]
then
  mkdir $BASE_DIR
fi
cd $BASE_DIR
for tpp in $plugins 
do
  if [ ! -d $BASE_DIR/$tpp ]
  then
    echo "cloning $tpp"
    git clone git://github.com/tpope/$tpp
  else
    cd $tpp
    echo "pulling $tpp"
    git pull 
    cd ..
  fi
done
if [ ! -d ${HOME}/.vim/autoload ]
then
  mkdir -p ${HOME}/.vim/autoload
fi

if [ ! -d ${HOME}/.vim/bundle ]
then
  mkdir -p ${HOME}/.vim/bundle
fi

if [ ! -d ${HOME}/.vim/doc ]
then
  mkdir -p ${HOME}/.vim/doc
fi

cd $BASE_DIR
if [ ! -h $HOME/.vim/autoload/pathogen.vim ]
then
  ln -s  $BASE_DIR/vim-pathogen/autoload/pathogen.vim $HOME/.vim/autoload/pathogen.vim
fi
if [ ! -h $HOME/.vim/colors/vividchalk.vim ]
then
  ln -s  $BASE_DIR/vim-vividchalk/colors/vividchalk.vim $HOME/.vim/colors/vividchalk.vim
fi
bundles="speeddating haml cucumber endwise surround unimpaired repeat abolish rails"
for bundle in $bundles
do
  if [ ! -h $HOME/.vim/bundle/$bundle.vim ]
  then
    ln -s $BASE_DIR/vim-$bundle/
  fi
done
