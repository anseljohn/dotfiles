#!/bin/bash

sudo -v

brew update
brew upgrade

xargs brew install < beer.txt
brew install stow
