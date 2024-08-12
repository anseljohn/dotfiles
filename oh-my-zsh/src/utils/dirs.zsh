USERD="$HOME"

OMJ_HOME="$USERD/.oh-my-john"
OH_MY_JOHN="$OMJ_HOME/oh-my-zsh/src"
ALIAS_LOC="$OH_MY_JOHN/aliases"
LOCAL_ALIAS_LOC="$OH_MY_JOHN/local_aliases"
declare -a alias_locs=($ALIAS_LOC $LOCAL_ALIAS_LOC)

DEV="$USERD/dev"
MONOREPO="$DEV/niantic"
MASSF="$MONOREPO/argeo/mapping-framework"
INFINITAM="$MONOREPO/argeo/infinitam"
MESHING37="$DEV/data/meshing37"
VIM_CONFIG="$USERD/.config/nvim/init.lua"
ALIASES="$USERD/.oh-my-zsh/custom/aliases.zsh"

# Meshing
statue="$MESHING37/sequences/20211122-133753_560ae00e-9dfa-4494-9c23-5419210fe1c3_1_of_1.tgz"