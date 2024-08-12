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

drcconv() {
  inf="$MONOREPO/bazel-bin/argeo/infinitam"
  if [ -d $inf ] && [[ -f $inf/draco_converter ]];
  then
    args=()
    base64="no"
    for arg in "$@"; do
      case "$arg" in
        "-base64")
          base64="yes"
          ;;
        *)
          args+="$arg"
      esac
    done

    use_draco=false
    for arg in "${args[@]}"; do
      if [[ "${$(basename $arg)##*.}" == "ply" ]];
      then
        use_draco=true
        break
      fi
    done

    if [ "$use_draco" = true ];
    then
      rp "$DEV/tools/draco/build_dir/draco_decoder -i $1 -o $2"
    else
      _dracoConverter="$MONOREPO/bazel-bin/argeo/infinitam/draco_converter"
      rp "$_dracoConverter $base64 $args"
    fi

  else
    if [[ "$1" == "--build" ]];
    then
      cd $MONOREPO
      build converter
      back
      drcconv ${@:2}
    else
      err "DracoConverter app is not build."
      echo "Please run 'bazel build -- //argeo/infinitam/Apps:DracoConverter' in the monorepo."
      echo "(You may have to add DracoConverter to the Apps BUILD file)"
      echo "or"
      echo "Run convdrc --build <args>"
    fi
  fi

}

build_with_script() {
  case $1 in
    "infinitam"|"mapping-framework")
      cd $MONOREPO/argeo/$1
      case $2 in
        "")
          ./bazel-build.sh
          ;;
        "cuda")
          ./bazel-build-cuda.sh
          ;;
        *)
          err "Invalid option '$2'"
      esac
      ;;
    *)
      err "Invalid option '$1'"
  esac
}

# Project stuff
build() {
    if isMonorepo ;
    then
      bb='bazel build '
      target=''
      scankit='-- //argeo/scaniverse/ScanKit/ScanKit/'
      infinitam='-- //argeo/infinitam'
      case $1 in
        '--debug')
          opts+=' --config debug'
          target+=$scankit'Neural/...'
          ;;
        'infinitam')
          build_with_script infinitam $2
          return
          ;;
        'massf')
          build_with_script mapping-framework $2
          return
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
        'rendersplats')
          target+=$scankit'Neural:RenderSplats'
          ;;
        '--targets')
          echo "Available targets:"
          echo "[infinitam, massf, pipeline, neural, scankit, rendersplats]"
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
      opts=${@:2}" "
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
        leftovers=${@:3:${#}}
        echo $leftovers
        rp "bazel run -- //argeo/scaniverse/ScanKit/ScanKit/Neural:TrainSplats \\
        $1 \\
        --output $2 \\
        --useDensePoints \\
        --disableExposureModel \\
        --useAppPhases \\
        --renderInterval 10 \\
        --pos 0.4,0,0 --target 0,0,-5 $leftovers"
      fi
  esac
}

renderSplats() {
  if [ "$@" -lt 1 ] || [ "$@" -gt 2 ];
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
    *)
      args=$@
      rp "bazel run -- //argeo/scaniverse/ScanKit/ScanKit/Neural:RenderSplats $args"
  esac
}

copyDepths() {
  if [ $# -lt 2 -o $# -gt 2 ];
  then
    err "Invalid number of arguments."
    echo "Syntax: copyDepths <path/to/RenderSplatsOutput> <path/to/RecorderV2Scan>"
  else
    python3 $MASSF/tools/scripts/meshing_tools/copy_splat_depths_to_v2.py $1 $2
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
      --renderInterval 0 \
      --pos 0.4,0,0 --target 0,0,-5
  else
    echo "You are not currently in the monorepo."
  fi
}

alias createmesh="python3 $MONOREPO/argeo/infinitam/scripts/MeshEval/mesh_create.py"
# renderSplats ~/prepped_scan_splat/step04200/model.ply --renderDepthBins --cameraPath --useCameras --rootPath ~/20211122-133753_560ae00e-9dfa-4494-9c23-5419210fe1c3_1_of_1.tgz --datasetType recorder_v2
# rendersplats: ply, 
# multidepth() {
#   if isMonorepo ;
#   then
#     case "$1" in
#       "-h")
#         echo "multidepth: Runs the MultiDepthConsole app."
#         echo "Usage: multidepth <opts> "
#         echo "Options:"
#         echo "\t-h: Display this help message."
#         ;;
#       "")
#         bazel run -- //argeo/infinitam/Apps:MultiDepthConsole
#         ;;
#       *)
#         echo "Invalid option '$1'"
#         return 1
#     esac
#   else
#     echo "You are not currently in the monorepo."
#   fi
# }
