alias pull='git pull'
alias fetch='git fetch'
alias clone='git clone'
alias check='git checkout'
alias stat='git status'
alias diff='git diff'
alias merge='git merge'
alias subup='git submodule update --init --recursive'
alias staged='git diff --cached'
alias gselect='git add -p'
alias stash='git stash'
alias pop='git stash pop'
alias rebase='git rebase'
alias add='git add'

commit() {
  if [[ $# -eq 0 ]]; 
  then
    echo "Please enter a commit message."
    exit 0
  fi

  for var in "$@"
  do
    if [[ "$var" == "-p" ]];
    then
      git commit --amend --no-edit
    else
      git commit -m $1
    fi
  done
}

push() {
  if [[ $# -eq  0 ]];
  then
    git push
  else
    if [[ "$1" == "--force" ]];
    then
      branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
      git push origin HEAD:$branch --force
    else
      git push $@
    fi
  fi
}

push_aliases() {
  cd $DEV/dotfiles/oh-my-zsh/src
  rm -rf aliases local_aliases main
  cp -r ~/.oh-my-john/* .

  success=$(git status 2>/dev/null)

  if [[ $success == *"nothing to commit"* ]];
  then
    echo "No updates required."
    return
  fi

  add . &>/dev/null
  commit 'Update aliases' &>/dev/null
  nullput "push"
  success=$(git status 2>/dev/null)

  if [[ $success == *"nothing to commit"* ]];
  then
    succ "Pushed alias changes."
  else
    err "Failed to push updated aliases."
    echo "Output:"
    echo "$success"
  fi

  back
}

push_vim() {
  cd $DEV/dotfiles/nvim
  rm -f init.lua
  cp ~/.config/nvim/init.lua .

  if [[ $success == *"nothing to commit"* ]];
  then
    echo "No updates required."
    return
  fi

  add . &>/dev/null
  commit 'Update nvim init' &>/dev/null
  nullput "push"
  success=$(git status 2>/dev/null)

  if [[ $success == *"nothing to commit"* ]];
  then
    succ "Pushed neovim init updates."
  else
    err "Failed to push updated neovim init."
    echo "Output:"
    echo "$success"
  fi

  back
}

update_aliases() {
  cd $DEV/dotfiles/
  pull &>/dev/null
  back
  cd oh-my-zsh
  ./setup.zsh
  succ "Aliases updated."
  back
}

update_vim() {
  cd $DEV/dotfiles/
  pull &>/dev/null
  back
  rm -rf ~/.config/nvim/init.lua
  cp nvim/init.lua ~/.config/nvim/
  succ "Neovim init updated."
  back
}
