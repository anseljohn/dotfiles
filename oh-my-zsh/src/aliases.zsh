# Load main aliases first
source ~/.oh-my-john/main/main.zsh

# Load generalized aliases
for file in ~/.oh-my-john/aliases/*; do
  source $file
done

# Load local aliases
for file in ~/.oh-my-john/local_aliases/*; do
  source $file
done
