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
      if [[ "$1" == '--debug' ]];
      then
        bazel build --config debug -- //argeo/scaniverse/ScanKit/ScanKit/Neural/...
      elif [[ "$1" == "-p" ]];
      then
	echo "bazel build -- //argeo/scaniverse/ScanKit/ScanKit/Neural/..."
      else
        bazel build -- //argeo/scaniverse/ScanKit/ScanKit/Neural/...
      fi

    else
        echo "Not in a buildable directory."
    fi
}

prepScan() {
  if isMonorepo ;
  then
    rm -rf /var/tmp/preparescan
    if [[ "$1" == "-a" ]];
    then
      $MONOREPO/bazel-out/darwin_arm64-fastbuild/bin/argeo/scaniverse/ScanKit/ScanKit/Neural/PrepareScan $statue
    else
      $MONOREPO/bazel-out/darwin_arm64-fastbuild/bin/argeo/scaniverse/ScanKit/ScanKit/Neural/PrepareScan $1
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
    if [[ "$1" != "-a" ]];
    then
      arg1="$1"
      arg2="$2"
    fi

    rm -rf $arg2

    bazel run -- //argeo/scaniverse/ScanKit/ScanKit/Neural:TrainSplats \
      $arg1 \
      --output $arg2 \
      --useDensePoints \
      --disableExposureModel \
      --useAppPhases \
      --renderInterval 10 \
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
