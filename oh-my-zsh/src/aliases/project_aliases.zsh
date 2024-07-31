# Determine directory/repo
isMonorepo() {
    if [[ $PWD/ =~ "/niantic/" ]];
    then
        return 0
    else
        return 1
    fi
}

alias _dracoConverter=$MONOREPO/bazel-bin/argeo/infinitam/Apps/DracoConverter
convdrc() {
  infapps="$MONOREPO/bazel-bin/argeo/infinitam/Apps"
  if [ -d $infapps ] && [[ -f $infapps/DracoConverter ]];
  then
    _dracoConverter $@
  else
    if [[ "$1" == "--build" ]];
    then
      cd $MONOREPO
      build converter
      back
    else
      err "DracoConverter app is not build."
      echo "Please run 'bazel build -- //argeo/infinitam/Apps:DracoConverter' in the monorepo."
      echo "(You may have to add DracoConverter to the Apps BUILD file)"
      echo "or"
      echo "Run convdrc --build <args>"
    fi
  fi
}

# Project stuff
build() {
    if isMonorepo ;
    then
      bb='bazel build'
      opts=''
      target=''
      scankit=' -- //argeo/scaniverse/ScanKit/ScanKit/'
      infinitam=' -- //argeo/infinitam/'
      case $1 in
        '--debug')
          opts+=' --config debug'
          target+=$scankit'Neural/...'
          ;;
        'pipeline')
          target+=$scankit'Pipeline/...'
          ;;
        'neural')
          target+=$scankit'Neural/...'
          ;;
        'scankit')
          target+=$scankit'...'
          ;;
        'converter')
          target+=$infinitam'Apps:DracoConverter'
          ;;
        'multidepth')
          target+=$infinitam'Apps:MultiDepth_Console'
          ;;
        '--targets')
          echo "Available targets:"
          echo "[pipeline, neural, converter, multidepth]"
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
          bazel run //argeo/scaniverse/ScanKit/ScanKit/Neural:PrepareScan -- $1 \
            --output $2 $3 $4 $5
        fi
    esac
  else
    echo "You are not currently in the monorepo."
  fi
}

trainSplats() {
  case "$1" in 
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
        rm -rf $3
        trainSplats ${@:2}
      fi
      ;;
    *)
      if [[ "$2" == "" ]];
      then
        echo "Invalid output directory."
        echo "Usage: trainSplats <path/to/prepped/scan> <path/to/output/folder>"
      else
        bazel run -- //argeo/scaniverse/ScanKit/ScanKit/Neural:TrainSplats \
          $1 \
          --output $2 \
          --useDensePoints \
          --disableExposureModel \
          --useAppPhases \
          --renderInterval 10 \
          --pos 0.4,0,0 --target 0,0,-5
      fi
  esac
}

renderSplats() {
  case "$1" in
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
    *)
      bazel run -- //argeo/scaniverse/ScanKit/ScanKit/Neural:RenderSplats \
        $@
  esac
}

copyDepths() {
  if [ $# -lt 2 -o $# -gt 2 ];
  then
    err "Invalid number of arguments."
    echo "Syntax: copyDepths <path/to/render> <path/to/recorderV2/folder>"
  else
    echo "python3 ~/dev/tools/SplatDepthToRV2/SplatDepthToRV2.py $1 $2"
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
