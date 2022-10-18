#!/bin/bash

# Copy zshrc file
cp .zshrc ~/.zshrc

# Setup starship
mkdir -p ~/.config
cp .config/starship.toml ~/.config/starship.toml
