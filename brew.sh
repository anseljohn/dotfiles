#!/bin/bash

sudo -v

brew update
brew upgrade

xargs brew install < ./beers.txt
brew install stow
