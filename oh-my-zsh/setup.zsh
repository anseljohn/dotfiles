#!/bin/zsh

mkdir -p ~/.oh-my-john
cp -r ./src/* ~/.oh-my-john
mv ~/.oh-my-john/aliases.zsh ~/.oh-my-zsh/custom
source ~/.zshrc