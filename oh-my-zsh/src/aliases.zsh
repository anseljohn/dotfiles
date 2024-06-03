# Load main aliases first
source ~/.oh-my-zsh/custom/main/main.zsh

# Load generalized aliases
for file in ~/.oh-my-zsh/custom/aliases/*; do
  source $file
done

# Load local aliases
for file in ~/.oh-my-zsh/custom/local_aliases/*; do
  source $file
done
