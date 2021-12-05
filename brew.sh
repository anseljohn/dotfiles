#!/bin/bash

sudo -v

brew update
brew upgrade

brew install --force $(cat beer.txt)
for i in $(cat beer.txt);
do
	brew install "$i"
done
