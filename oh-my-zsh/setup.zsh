#!/bin/zsh

rm -rf ~/.oh-my-john
mkdir -p ~/.oh-my-john
cp -r ~/dev/dotfiles/oh-my-zsh/src/* ~/.oh-my-john
cp -fr ~/.oh-my-john/aliases.zsh ~/.oh-my-zsh/custom
source ~/.zshrc