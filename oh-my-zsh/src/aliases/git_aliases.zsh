alias pull='git pull'
alias fetch='git fetch'
alias clone='git clone'
alias stat='git status'
alias diff='git diff'
alias subup='git submodule update --init --recursive'
alias staged='git diff --cached'
alias gselect='git add -p'
alias stash='git stash'
alias pop='git stash pop'
alias rebase='git rebase'
alias add='git add'
alias branch='git rev-parse --abbrev-ref HEAD'
alias check='git checkout'

merge() {
  curr_branch=$(branch)

  if [[ "$curr_branch" == "main" ]];
  then
    echo "Already on 'main'"
  else
    if [[ "$1" == "" ]];
    then
        echo "Invalid branch"
    else
      echo "fetch origin"
      echo "merge $1"
    fi
  fi
}

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
    echo "No alias updates required."
    back
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
    echo "No vim updates required."
    back
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

pull_aliases() {
  currd=$(pwd)
  cd $DEV/dotfiles/

  if [[ $(git fetch --dry-run 2>/dev/null) == "" ]];
  then
    echo "Aliases are up to date."
  else
    pull &>/dev/null
    cd oh-my-zsh
    ./setup.zsh
    succ "aliases updated."
  fi
  back
}

pull_vim() {
  cd $DEV/dotfiles/

  if [[ $(git fetch --dry-run 2>/dev/null) == "" ]];
  then
    echo "Vim config is up to date."
  else
    pull &>/dev/null
    rm -rf ~/.config/nvim/init.lua
    cp nvim/init.lua ~/.config/nvim/
    succ "neovim init updated."
  fi
  back
}

pull_config() {
  VO=$(pull_vim)
  AO=$(pull_aliases)

  if [ "$V0" == *"up to date"* ] && [ "$AO" == *"up to date"* ];
  then
    echo "Configs are up to date."
  else
    echo "$VO"
    echo "$AO"
  fi
}

push_config() {
  VO=$(push_vim)
  AO=$(push_aliases)
  
  if [[ "$V0" == "$AO" ]];
  then
    echo "Configs are up to date."
  else
    echo "wat"
    echo "$VO"
    echo "$AO"
  fi
}
