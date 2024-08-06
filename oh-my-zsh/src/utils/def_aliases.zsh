typeset -A _aliases=( ["git"]="$git_aliases" ["project"]="$project_aliases" ["vm"]="$vm_aliases" ["docker"]="$docker_aliases" )

declare -A git_aliases
git_aliases="
  pull,
  fetch,
  clone,
  stat,
  diff,
  subup,
  staged,
  gselect,
  pop,
  rebase,
  reset,
  add,
  branch,
  merge,
  check,
  stash,
  commit,
  push"

declare -A project_aliases
project_aliases="
  drcconv,
  build,
  prepScan,
  trainSplats,
  renderSplats,
  multidepth,
  copyDepths,
  benchmark,
  mesheval,
  createmesh"

declare -A vm_aliases
vm_aliases="
  vm,
  vmcp,
  vmup"

declare -A docker_aliases
docker_aliases="
  dk list,
  dk enter,
  dk start,
  dk build,
  dk stop,
  dk kill,
  dk cp"
