# Sourcing
for file in ~/.oh-my-john/utils/*; do
  source $file
done

for loc in ${alias_locs[@]}; do
  for file in $loc/*; do
    source $file
  done
done

aliases() {
  case "$1" in 
    "-git")
      echo "Print git commands"
      ;;
    *)
      echo "what the fuck"
  esac
}

reload() {
  if [[ "$1" == "-c" ]];
  then
    clear
  fi
  exec zsh
}
