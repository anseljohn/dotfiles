# Load main aliases first
source ~/.oh-my-john/custom/main/main.zsh

# Load generalized aliases
for file in ~/.oh-my-john/custom/aliases/*; do
  source $file
done

# Load local aliases
for file in ~/.oh-my-john/custom/local_aliases/*; do
  source $file
done
