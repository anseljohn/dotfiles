#!/bin/zsh

mkdir -p ~/.oh-my-john
cp -r ./src/* ~/.oh-my-john
mv ~/.oh-my-john/aliases.zsh ~/.oh-my-zsh/custom
exec zsh

echo "Alias setup complete. Remember to change ~/.oh-my-john/main/local_aliases.zsh to match local env."
