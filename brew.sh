#!/bin/bash

sudo -v

brew update
brew upgrade

brew install $(cat beer.txt)
