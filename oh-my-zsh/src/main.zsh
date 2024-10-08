#!/bin/zsh

# Sourcing
for file in ~/.oh-my-john/oh-my-zsh/src/env/*; do
  set -a; source $file; set +a
done

for file in ~/.oh-my-john/oh-my-zsh/src/utils/*.zsh; do
  source $file
done

declare -a alias_locs=($ALIAS_LOC $LOCAL_ALIAS_LOC)
for loc in ${alias_locs[@]}; do
  for file in $loc/*.zsh; do
    source $file
  done
done

source $OH_MY_JOHN/utils/def_aliases.zsh

aliases() {
  groups=("git" "project" "vm" "docker")
  case "$1" in 
    "")
      for alias_group in ${groups[@]}; do
        aliases $alias_group
        echo
      done
      ;;
    "git")
      echo -n "Git aliases:"
      echo $git_aliases
      ;;
    "project")
      echo -n "Project aliases:"
      echo $project_aliases
      ;;
    "vm")
      echo -n "VM aliases:"
      echo $vm_aliases
      ;;
    "docker")
      echo -n "Docker aliases:"
      echo $docker_aliases
      ;;
    "groups")
      echo "Available groups: [$groups]"
      ;;
    *)
      err "Invalid alias group '$1',"
      echo "Available groups: [$groups]"
  esac
}

reload() {
  if [[ "$1" == "-c" ]];
  then
    clear
  fi
  source ~/.zshrc
}
