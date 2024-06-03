#!/bin/zsh

mkdir -p ~/.oh-my-john
cp -r ./src/* ~/.oh-my-john
mv ~/.oh-my-john/aliases.zsh ~/.oh-my-zsh/custom
source ~/.zshrc

echo "Alias setup complete. Remember to change ~/.oh-my-john/local_aliases to match local env."