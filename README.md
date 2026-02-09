# dotfiles

Personal dotfiles for macOS/POSIX environments.

## What's Included

| File | Description |
|------|-------------|
| `.zshrc` | Zsh config with aliases (git, npm, k8s, terraform), tool initialization (pyenv, rbenv, nvm, gcloud), and Starship prompt |
| `.gitconfig` | Git config with GPG signing, vim editor, `main` as default branch |

## Prerequisites

- [Zsh](https://www.zsh.org/)
- [Starship](https://starship.rs/)
- [podman](https://podman.io/)
- [GNU sed](https://www.gnu.org/software/sed/) (`brew install gnu-sed`)
- A `~/.env` file exporting tool paths (see top of `.zshrc` for expected variables)

## Setup

```sh
./setup.sh
source ~/.zshrc
```
