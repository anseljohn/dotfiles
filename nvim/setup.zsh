rm -f ~/.config/nvim/init.lua
cp ./init.lua ~/.config/nvim

brew install cmake python go nodejs

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim --headless +PlugInstall +qall
nvim --headless +CocInstall +coc-clangd
