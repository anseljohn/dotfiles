# Determine directory/repo
isMonorepo() {
    if [[ $PWD/ =~ "/niantic/" ]];
    then
        return 0
    else
        return 1
    fi
}

alias emono="code $MONOREPO"
alias multidepth_console="$MONOREPO/bazel-bin/argeo/infinitam/multidepth_console"

drcconv() {
    base64="no"
    use_draco=false
    for arg in "$@"; do
      if [[ "$arg" == "-base64" ]];
      then
        base64="yes"
        break
      elif [[ "$arg" == *".ply"* ]];
      then
        use_draco=true
        break
      fi
    done

    if [ "$use_draco" = true ];
    then
      p3 $DRACO $DRACO_DECODER $1 $2
    else
      p3 $DRACO $DRACO_CONVERTER $1 $2 $base64
    fi
}


# Project stuff
build() {
  cmd="p3 $BAZEL_BUILD"

  case $1 in
    "-h")
      cmd="$cmd -h"
      ;;
    *)
      cmd="$cmd --project $1"

      if [[ "$2" == "cuda" ]];
      then
        cmd="$cmd --cuda"
      fi
      ;;
  esac

  eval "$cmd"
}

prepScan() {
  if isMonorepo ;
  then
    case $1 in
      '-a')
        rm -rf ~/prepped_scan
        bazel run //argeo/scaniverse/ScanKit/ScanKit/Neural:PrepareScan -- $statue \
          --output ~/prepped_scan
        ;;
      *)
        if [[ "$2" == "" ]];
        then
          echo "Invalid output."
          echo "Usage: prepScan <path/to/scan.tgz> <path/to/output/folder>"
        else
          rp "bazel run -- //argeo/scaniverse/ScanKit/ScanKit/Neural:PrepareScan $1 --output ${@:2}"
        fi
    esac
  else
    echo "You are not currently in the monorepo."
  fi
}

trainSplats() {
  case "$1" in 
    "-h")
      echo "trainSplats: Trains a neural network to predict splats from a prepped scan."
      echo "\tUsage: trainSplats <opts> <path/to/prepped/scan> <path/to/output/folder>"
      echo "Options:"
      echo "\t-d: Delete the output directory before running."
      echo "\t-h: Display this help message."
      ;;
    "")
      echo "Invalid input."
      echo "Usage: trainSplats <path/to/prepped/scan> <path/to/output/folder>"
      ;;
    "-d")
      if [[ "$3" == "" ]];
      then
        echo "Invalid output directory."
        echo "Usage: trainSplats <path/to/prepped/scan> <path/to/output/folder>"
      else
        rm -rf $3 && trainSplats ${@:2}
      fi
      ;;
    *)
      if [[ "$2" == "" ]];
      then
        echo "Invalid output directory."
        echo "Usage: trainSplats <path/to/prepped/scan> <path/to/output/folder>"
      else
        leftovers=${@:3:${#}}
        echo $leftovers
        rp "bazel run -- //argeo/scaniverse/ScanKit/ScanKit/Neural:TrainSplats \\
        $1 \\
        --output $2 \\
        --useDensePoints \\
        --disableExposureModel \\
        --renderInterval 10 \\
        --pos 0.4,0,0 --target 0,0,-5 $leftovers"
        cat $2/stats.txt
      fi
  esac
}

renderSplats() {
  if [ "$#" -lt 1 ] || [ "$#" -gt 2 ];
  then
    echo "Invalid syntax."
    echo "Usage: renderSplats <opts> </path/to/model.ply>"
    return 0
  fi

  case "$1" in
    "-h")
      echo "renderSplats: Renders splats from a prepped scan."
      echo "\tUsage: renderSplats <opts> </path/to/model.ply>"
      echo "Options:"
      echo "\t-d: Delete the output directory before running."
      echo "\t-h: Display this help message."
      ;;
    "-d")
      rm -rf /var/tmp/rendersplats
      if [[ "$2" == "" ]];
      then
        echo "Invalid syntax."
        echo "Usage: renderSplats <opts> </path/to/model.ply>"
      else
        renderSplats ${@:2}
      fi
      ;;
    "mass")
      p3 $M37_UTILS render $2 $MESHING37
      ;;
    *)
      args=$@
      rp "bazel run -- //argeo/scaniverse/ScanKit/ScanKit/Neural:RenderSplats $args"
  esac
}

copyDepths() {
  if [ $# -lt 2 -o $# -gt 3r ];
  then
    err "Invalid number of arguments."
    echo "Syntax: copyDepths (mass) <path/to/RenderSplatsOutput> <path/to/RecorderV2Scan>"
  else
    case "$1" in
      "mass")
        p3 $M37_UTILS copyDepths $2 $3 $MASSF
        ;;
      *)
        p3 $MASSF/tools/scripts/meshing_tools/copy_splat_depths_to_v2.py $1 $2
    esac
  fi
}

copyMasks() {
  if [ $# -ne 2 ];
  then
    err "Invalid number of arguments."
    echo "Syntax: copyMasks <path/to/multidepth_console/output> <path/to/prepareScanOutput>"
  else
    ~/dev/tools/SkySegmentation/copy_sky_masks.sh $1 $2
  fi
}

benchmark() {
  if isMonorepo ;
  then
    arg1=/var/tmp/preparescan
    arg2=~/prep-scan-testing-output

    case "$1" in
      "-a")
        continue
        ;;
      "-i")
        if [[ "$2" == "" ]];
        then
          err "Invalid syntax."
          echo "Syntax: benchmark -i /path/to/prepped_scan"
        else
          arg1="$2"
        fi
        ;;
      *)
        echo "Invalid option '$1'"
        return 1
    esac

    rm -rf $arg2

    bazel run -- //argeo/scaniverse/ScanKit/ScanKit/Neural:TrainSplats \
      $arg1 \
      --output $arg2 \
      --useDensePoints \
      --disableExposureModel \
      --useAppPhases \
      --valAllFrames \
      --renderInterval 0 \
      --pos 0.4,0,0 --target 0,0,-5
  else
    echo "You are not currently in the monorepo."
  fi
}

createmesh() {
  if [[ "$1" == *".txt"* ]];
  then
    p3 $M37_UTILS create $1
  elif [[ $# -ge 2 ]];
  then
    p3 $M37_UTILS create $1 $2 $NETS
  else
    err "Invalid number of arguments."
    echo "Usage:"
    echo "\tcreatemesh <path/to/config.txt>"
    echo "\tcreatemesh <path/to/sequence.tgz> <path/to/output/folder>"
  fi
}

mesheval() {
  if [[ $# -eq 1 ]];
  then
    p3 $M37_UTILS eval $1
  else
    err "Invalid number of arguments."
    echo "Usage: mesheval <path/to/config.txt>"
  fi
}

m37() {
  case $1 in
    "-d")
      if [[ "$2" == "" ]];
      then
        err "Invalid output directory."
        echo "Syntax: m37 -d <path/to/output/folder>"
      else
        if [[ "$3" == "" ]];
        then
          rm -rf $DEV/data/meshing_from_splats
        else
          rm -rf $3
        fi

        m37 ${@:2}
      fi
      ;;
    "config")
      call="p3 $M37_UTILS config"
      if [[ "$2" != "" ]];
      then
        call="$call $2"
      fi
      eval "$call"
      ;;
    *)
      call="p3 $M37_UTILS setup $1 $MESHING37"
      if [[ "$2" != "" ]];
      then
        call="$call $2"
      fi
      eval "$call"
  esac
}

genConfig() {
  if [[ $# -eq 2 ]];
  then
    p3 $JOB_SUBMITTER $1 $2
  else
    err "Invalid number of arguments."
    echo "Usage: genConfig <path/to/config.txt>"
  fi
}