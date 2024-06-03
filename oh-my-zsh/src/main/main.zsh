source ~/.oh-my-zsh/custom/main/local_aliases.zsh
# Dirs/global vars
DEV="$USERD/dev"
MONOREPO="$DEV/niantic"
MESHING37="$DEV/data/meshing37"
VIM_CONFIG="$USERD/.config/nvim/init.lua"
ALIASES="$USERD/.oh-my-zsh/custom/aliases.zsh"

mycoms() {
    echo "Git:"
    echo "\tadd (git add)"
    echo "\tcommit (git commit -m)"
    echo "\tpush (git push)"
    echo "\tpull (git pull)"
    echo "\tfetch (git fetch)"
    echo "\tclone (git clone)"
    echo "\tcheck (git checkout)"
    echo "\tstat (git status)"
    echo "\tdiff (git diff)"
    echo "\tmerge (git merge)"
}

alias vim='nvim'
alias evim="vim $VIM_CONFIG"
alias ealias="vim $ALIASES"
alias ohmy="cd $USERD/.oh-my-zsh"

ccp() {
  $@ | cpcm
}

# Meshes
statue="$MESHING37/sequences/20211122-133753_560ae00e-9dfa-4494-9c23-5419210fe1c3_1_of_1.tgz"

# To Dirs
alias mono="cd $MONOREPO"
alias dev="cd $DEV"
alias down="cd $USERD/Downloads"
alias back="cd - > /dev/null"

# Misc
alias rmf='rm -rf'
alias rms='rm -rf *'
alias reload='exec zsh'
alias x='exit'
alias fuck='figlet "fuck $@"'
alias fucking='figlet "fucking $@"'
alias fuckin='figlet "fuckin $@"'
alias FUCK='figlet "FUCK $@"'
