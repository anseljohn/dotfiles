USERD="$HOME"

OMJ_HOME="$USERD/.oh-my-john"
OH_MY_JOHN="$OMJ_HOME/oh-my-zsh/src"
ALIAS_LOC="$OH_MY_JOHN/aliases"
LOCAL_ALIAS_LOC="$OH_MY_JOHN/local_aliases"
declare -a alias_locs=($ALIAS_LOC $LOCAL_ALIAS_LOC)

UTILS="$OH_MY_JOHN/utils"
DEV="$USERD/dev"
MONOREPO="$DEV/niantic"
MASSF="$MONOREPO/argeo/mapping-framework"
INFINITAM="$MONOREPO/argeo/infinitam"
NETS="$INFINITAM/Files/Nets"
MESHING37="$DEV/data/meshing37"
VIM_CONFIG="$USERD/.config/nvim/init.lua"
ALIASES="$USERD/.oh-my-zsh/custom/aliases.zsh"

# Python alias stuff
DRACO="$OH_MY_JOHN/draco.py"

# Tools
DRACO_DECODER="$DEV/tools/draco/build_dir/draco_decoder"
DRACO_CONVERTER="$MONOREPO/bazel-bin/argeo/infinitam/draco_converter"

# Meshing
statue="$MESHING37/sequences/20211122-133753_560ae00e-9dfa-4494-9c23-5419210fe1c3_1_of_1.tgz"