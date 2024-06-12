# Dirs/global vars
USERD="$HOME"
ALIAS_LOC="$USERD/.oh-my-john/aliases"
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

nullput() {
  $@ 2>/dev/null
}

alias vim='nvim'
alias evim="vim $VIM_CONFIG"
alias ealias="vim $USERD/.oh-my-john"
alias ohmy="cd $USERD/.oh-my-zsh"

# Logging
succ() {
  if [ $# -eq 1 ];
  then
    echo "${Green}Success:${Color_Off} $1"
  else
    err "Invalid syntax."
    echo 'Syntax: err <"Error Statement">'
  fi
}

err() {
  if [ $# -eq 1 ];
  then
    echo "${Red}Error:${Color_Off} $1"
  else
    err "Invalid syntax."
    echo 'Syntax: err <"Error Statement">'
  fi
}

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
alias x='exit'
alias fuck='figlet "fuck $@"'
alias fucking='figlet "fucking $@"'
alias fuckin='figlet "fuckin $@"'
alias FUCK='figlet "FUCK $@"'

reload() {
  if [[ "$1" == "-c" ]];
  then
    clear
  fi
  exec zsh
}


# COLORS
# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White

