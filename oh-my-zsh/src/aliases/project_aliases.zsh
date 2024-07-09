# Determine directory/repo
isMonorepo() {
    if [[ $PWD/ =~ "/niantic/" ]];
    then
        return 0
    else
        return 1
    fi
}


# Project stuff
build() {
    if isMonorepo ;
    then
      bb='bazel build'
      opts=''
      target=' -- //argeo/scaniverse/ScanKit/ScanKit/'
      case $1 in
        '--debug')
          opts+=' --config debug'
          target+='Neural/...'
          ;;
        'pipeline')
          target+='Pipeline/...'
          ;;
        'neural')
          target+='Neural/...'
          ;;
        '--targets')
          echo "Available targets:"
          echo "[pipeline, neural]"
          echo "ex."
          echo "$ build neural"
          return 1
          ;;
        *)
          echo "Invalid build target."
          echo "ex."
          echo "$ build neural : runs bazel build -- //argeo/scaniverse/ScanKit/ScanKit/Neural/..."
          return 0
        ;;

      esac
      fs=$bb$opts$target
      echo "Running '$fs'"
      eval $fs
    else
        echo "Not in a buildable directory."
    fi
}

prepScan() {
  if isMonorepo ;
  then
    if [[ "$1" == "-a" ]];
    then
      rm -rf ~/prepped_scan
      bazel run //argeo/scaniverse/ScanKit/ScanKit/Neural:PrepareScan -- $statue \
        --output ~/prepped_scan
    else
      rm -rf ~/scaniverse-benchmark-pradofountain-data
      bazel run //argeo/scaniverse/ScanKit/ScanKit/Neural:PrepareScan -- $1 \
        --output ~/scaniverse-benchmark-pradofountain-data
    fi
  else
    echo "You are not currently in the monorepo."
  fi
}

# Directory dependent
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
      --renderInterval 0 \
      --pos 0.4,0,0 --target 0,0,-5
  else
    echo "You are not currently in the monorepo."
  fi
}

renderSplats() {
  if isMonorepo ;
  then
    arg="prep-scan-testing-output"

    if [[ "$1" != "-a" ]];
    then
      arg="scaniverse-benchmark-output"
    fi

    bazel run -- //argeo/scaniverse/ScanKit/ScanKit/Neural:RenderSplats \
      "$HOME/$arg/step00900/model.ply" \
      --orbit --target 0,-0.2,-3 --radius 3 --pitch -5 --width 1920

    bazel run -- //argeo/scaniverse/ScanKit/ScanKit/Neural:RenderSplats \
      "$HOME/$arg/step01300/model.ply" \
      --orbit --target 0,-0.2,-3 --radius 3 --pitch -5 --width 1920

    bazel run -- //argeo/scaniverse/ScanKit/ScanKit/Neural:RenderSplats \
      "$HOME/$arg/step03600/model.ply" \
      --orbit --target 0,-0.2,-3 --radius 3 --pitch -5 --width 1920
  else
    echo "You are not currently in the monorepo."
  fi
}
