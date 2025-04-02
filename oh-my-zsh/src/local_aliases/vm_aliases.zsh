VM_HOME="/home/johnanselmo_nianticlabs_com"
VM_ALIAS="$VM_HOME/.oh-my-zsh/custom/"
VM_VIM_CONFIG="$VM_HOME/.config/nvim/"

VM_NAME="johnanselmo-ubuntu-focal"
VM_PROJECT_NAME="corp-work-machines"
VM_ZONE="us-west1-b"
VM_COMMAND="gcloud compute ssh $VM_NAME --project=corp-work-machines --zone=us-west1-b"

vm() {
  if [[ "$1" == "project" ]];
  then
    echo "$VM_PROJECT_NAME"
  elif [[ "$1" == "machine" ]];
  then
    echo " $VM_NAME"
  elif [[ "$1" == "zone" ]];
  then
    echo "$VM_ZONE"
  elif [[ "$1" == "command" ]];
  then
    echo "$VM_COMMAND"
  else
    eval "$VM_COMMAND"
  fi
}

vmcp() {
  if [[ "$#" -le 0 ]];
  then
    echo "Illegal number of arguments."
    echo "Usage: vmcp <source-file> <vm-name>:<vm-destination>"
    echo " - Swap arguments for remote to local copy."
    echo "or"
    echo "vmcp:"
    echo "\t--vim | copies vim config"
    echo "\t--aliases | copies zsh aliases"
  else
    case "$1" in
      "--vim")
        vmcp $VIM_CONFIG $VM_VIM_CONFIG
        ;;
      "--aliases")
        for file in $ALIAS_LOC/*; do
          
        done
        #vmcp $ALIASES $VIM_ALIASES
        ;;
      *)
        gcloud compute scp $1 $2 --zone "us-west1-b"
    esac
  fi
}