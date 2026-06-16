#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

link() {
  mkdir -p "$(dirname "$2")"
  ln -sf "$1" "$2"
  echo "Linked $1 -> $2"
}

# Home directory dotfiles
link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
link "$DOTFILES_DIR/.npmrc" "$HOME/.npmrc"

# .config files
link "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"

echo "Done. Run 'source ~/.zshrc' to reload."
