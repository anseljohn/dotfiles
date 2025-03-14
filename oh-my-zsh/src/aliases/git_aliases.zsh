
alias git_aliases="echo $git_aliases"

alias fetch='git fetch'
alias clone='git clone'
alias stat='git status'
alias diff='git diff'
alias subup='git submodule update --init --recursive'
alias staged='git diff --cached'
alias gselect='git add -p'
alias pop='git stash pop'
alias add='git add'
alias merge='git merge'
alias check='git checkout'

branches() {
  p3 $GITPY branches $@
}

rebase() {
  case "$1" in
  "")
    err "Please specify a branch to rebase against."
    ;;
  *)
    git fetch origin $1 && git rebase -i origin/$1
  esac
}

reset() {
  p3 $GITPY_DIR/reset.py $@
}

stash() {
  case $1 in
    "")
      git stash
      ;;
    "list"|"show"|"drop"|"apply")
      git stash $@
      ;;
    *)
      git stash push -m $1
      ;;
  esac
}

branch() {
  case $1 in
    "")
      git rev-parse --abbrev-ref HEAD
      ;;
    "list")
      git branch
      ;;
    "delete")
      git branch -D $2
      ;;
    *)
      err "Invalid argument: $1"
      echo "Syntax: branch <list|delete>"
      ;;
  esac
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
  case $1 in
    "")
      # p3 $GITPY push
      git push
      ;;
    "--force")
      # p3 $GITPY push --force
      branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
      git push origin HEAD:$branch --force
      ;;
    "aliases")
      push_aliases $2
      ;;
    "vim")
      push_vim
      ;; 
    *)
      git push $@
      ;;
  esac
}

pull() {
  case $1 in
    "aliases")
      pull_aliases
      ;;
    *)
      git pull $@
      ;;
  esac
}

push_aliases() {
  cd $OMJ_HOME
  success=$(git status 2>/dev/null)

  case "$1" in
    "")
      if [[ $success == *"nothing to commit"* ]];
      then
        echo "No alias updates to push."
        back
        return
      fi
      echo "Pushing alias changes..."
      add . &>/dev/null

      ;;
    "-s")
      gselect
      ;;
    "help")
      echo "Syntax: push aliases <opts>"
      echo "Options:"
      echo "  -s: stage changes"
      echo "  <empty>: auto push"
      return
      ;;
    *)
      err "Invalid argument: $1"
      echo "Syntax: push aliases <opts>"
      echo "Options:"
      echo "  -s: stage changes"
      echo "  <empty>: auto push"
  esac

  commit 'Update aliases' &>/dev/null
  staged=$(git status 2>/dev/null)
  nullput "push"
  success=$(git status 2>/dev/null)

  if [[ $success == *"nothing to commit"* ]] || [[ $staged == *"Changes to be committed"* ]] || [[ $staged == *"Changes not staged for commit"* ]];
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
  cd $OMJ_HOME/nvim
  rm -f init.lua
  cp ~/.config/nvim/init.lua .

  if [[ $success == *"nothing to commit"* ]];
  then
    echo "No vim updates to push."
    back
    return
  fi
  
  echo "Pushing neovim changes..."
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
  cd $OMJ_HOME
  pull &>/dev/null
  back
  succ "Aliases updated, zsh reloaded."
  reload
}

pull_vim() {
  cd $OMJ_HOME
  pull &>/dev/null
  rm -rf ~/.config/nvim/init.lua
  cp nvim/init.lua ~/.config/nvim/
  succ "neovim init updated."
  back
}

pull_config() {
  VO=$(pull_vim)
  AO=$(pull_aliases)

  if [[ $V0 =~ "up to" ]] && [[ $AO =~ "up to" ]];
  then
    echo "Configs are up to date."
  else
    echo "$VO"
    echo "$AO"
  fi
}
