# Author: Daniel Jimenez
#
# Requires:
# GNU-SED on Mac

# load env vars, should export the following envs when relevant:
#
# export HOMEBREW_DIR="/opt/homebrew"
# export JDK_ROOT="$HOMEBREW_DIR/opt/openjdk/bin"
# export PYENV_ROOT="$HOME/.pyenv"
# export RBENV_ROOT="$HOME/.rbenv"
# export NVM_ROOT="$HOME/.nvm"
# export POSTGRES_ROOT="/opt/postgres/12"
# export LIBFFI_ROOT="$HOMEBREW_DIR/opt/libffi"

source $HOME/.env

# homebrew
if command -v brew &> /dev/null; then
  eval "$($HOMEBREW_DIR/bin/brew shellenv)"
fi

# starship
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# zsh history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# core
alias ll="ls -al"
alias sed="gsed"
alias scrcpy="scrcpy"
alias rosetta="arch -x86_64"

# git
alias g="git"
alias ga="git add ."
alias gb="git branch"
alias gc="git checkout"
alias gl="git log"
alias gp="git push"
alias gs="git status"
alias gbc="git checkout -b"
alias gbl="git branch --list"
alias gcm="git commit -m"
alias gfo="git fetch origin"
alias gfu="git fetch upstream"
alias gpf="git push -f"
alias grc="git rebase --continue"
alias grm="git rebase main"
alias grho="git reset --hard origin/main"
alias grhu="git reset --hard upstream/main"
alias grmi="git rebase main --interactive"
alias guo="gfo && grho && gpf && gc main && grho && gc develop"

# git clean local branches - removes local branches no longer on origin
gclb() {
  git fetch -p
  while read -r branch; do
    git branch -D "$branch"
  done <<< "$(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}')"
}

# npm
alias nr="npm run"
alias ns="npm start"
alias nrl="npm run lint"
alias nrt="npm run test"
alias nrtq="npm run test:quick --"
alias nrtu="npm run test:unit"
alias ncu="ncu -x eslint-config-spoke"

# terraform
alias tf="terraform"

# kubernetes
alias k="kubectl"
alias kctx="kubectx"
aliax kns="kubens"

# allow multitasking on macOS
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# gpg
export GPG_TTY="$(tty)"

# paths
export PATH="$PATH:$JDK_ROOT/bin"
export PATH="$PATH:$PYENV_ROOT/bin"
export PATH="$PATH:$RBENV_ROOT/bin"

# libffi fixes for ruby
if [ ! -z "${LIBFFI_ROOT}" ]; then
  export LDFLAGS="-L$LIBFFI_ROOT/lib"
  export CPPFLAGS="-I$LIBFFI_ROOT/include"
  export PKG_CONFIG_PATH="$LIBFFI_ROOT/lib/pkgconfig"
fi

# nvm
if [ ! -z "${NVM_ROOT}" ]; then
  export NVM_DIR="$NVM_ROOT"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# gcloud
if [ ! -z "${HOMEBREW_DIR}" ]; then
  source "$HOMEBREW_DIR/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  source "$HOMEBREW_DIR/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi

# pyenv
if command -v pyenv &> /dev/null; then
  eval "$(pyenv init --path)"
fi

# rbenv
if command -v rbenv &> /dev/null; then
  eval "$(rbenv init -)"
fi

# h5py
if [ ! -z "${HOMEBREW_DIR}" ]; then
  export HDF5_DIR="$HOMEBREW_DIR/opt/hdf5"
fi

# psql
if [ ! -z "${POSTGRES_ROOT}" ]; then
  alias psql="$POSTGRES_ROOT/scripts/runpsql.sh"
fi
