#!/bin/bash

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH
echo "export PATH=/opt/homebrew/bin:$PATH" >> ~/.bashrc && source ~/.bashrc
