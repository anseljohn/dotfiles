#!/bin/zsh

rm -rf ~/.oh-my-john
dotfiles=$(dirname $( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd ))
configd=$(dirname $dotfiles)/.oh-my-john
mv $dotfiles $configd
mv $configd ~

cp -fr ~/.oh-my-john/oh-my-zsh/src/aliases.zsh ~/.oh-my-zsh/custom
source ~/.zshrc

# Cleanup
echo rm -rf $dotfiles