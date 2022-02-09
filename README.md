Installation:

```
# cd to ~
cd

# clone this repo to .vim
git clone https://github.com/mapehe/vim_conf.git .vim

# install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# soft link .vimrc
ln -s ~/.vim/.vimrc ~/.vimrc
```

Start vim, run `:PlugInstall` and you're good to go 💎!

