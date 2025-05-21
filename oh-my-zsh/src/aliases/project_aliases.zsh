# Determine directory/repo
isMonorepo() {
    if [[ $PWD/ =~ "/spatial/" ]];
    then
        return 0
    else
        return 1
    fi
}

alias gauth="gcloud auth application-default login"

getspace() {
  if ! conda info --envs | grep -q "^get-space "; then
    echo "getspace conda env does not exist. Creating it..."
    conda create -y -n get-space python=3.10
    conda activate get-space
    python -m pip install argparse gcloud google-cloud-storage google-cloud-spanner
    echo "DONE"
    python ~/dev/tools/tk/get_space.py $@
  else
    conda run -n get-space python ~/dev/tools/tk/get_space.py $@
  fi
}

vcp() {
  if [[ "$#" -eq 2 ]]; then
    if [[ $1 == gs* ]]; then   # True if $a starts with a "z" (wildcard matching).
      if [ -d "$2" ]; then
        gcloud storage cp -r $1 $2
      else
        mkdir -p $2
        vcp $1 $2
      fi
    elif [[ $1 == *:* ]] || [[ $2 == *:* ]]; then
      gcloud compute scp $1 $2 --zone "us-west1-b"
    else
      echo "Invalid syntax."
      echo "Usage: vcp [-vm | -gs] <src> <dst>"
      echo "Copy gcloud file:"
      echo "\tvcp gs://bucket/file.txt ~/path/to/local/dst.txt"
      echo "Copy to/from vm:"
      echo "\tvcp VM_NAME:/path/to/file.txt ~/path/to/local/dst.txt"
      echo "\tvcp ~/path/to/local/src.txt VM_NAME:/path/to/file.txt"
    fi
  else
    echo "Invalid syntax."
    echo "Usage: vcp [-vm | -gs] <src> <dst>"
    echo "Copy gcloud file:"
    echo "\tvcp gs://bucket/file.txt ~/path/to/local/dst.txt"
    echo "Copy to/from vm:"
    echo "\tvcp VM_NAME:/path/to/file.txt ~/path/to/local/dst.txt"
    echo "\tvcp ~/path/to/local/src.txt VM_NAME:/path/to/file.txt"
  fi
  # if [[ "$#" -eq 2 ]]; then
  #   gcloud compute scp $1 $2 --zone "us-west1-b"
  # elif [[ "$#" -eq 1 ]]; then
  #   if [ -d "$1" ]; then
  #     gcloud storage cp -r $1
  #   else
  #     mkdir -p $1
  #     vcp $1
  #   fi
  # else
  #   echo "Invalid syntax."
  #   echo "Usage:"
  # fi
}

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


# Mapping utilities
monitor() {
  if [ "$#" -lt 2 ] || [ "$#" -gt 2 ]; then
    err "Invalid syntax."
    echo "Usage: monitor mc-workflow-name cluster-name"
  else
    cd $MAP_UTILS
   ./mapping_utilities connect-dashboard -w $1 -e $2 
   back
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

monjob() {
  if [[ "$#" -eq 2 ]]; then
  else
  fi
  # ./mapping_utilities connect-dashboard -w mc-20250327213111-77df896 -e map-stagingc-usc1-cluster
}

cppoi-act() {
  if [[ "$#" -eq 3 ]]; then
    echo "Copying POI(s) from $2 to $3..."
    cppoi $1 $2 $3
    echo "Done.\n"
    echo "Activating wayspots on $3..."
    activateWayspot $1 $3
    echo "Done."
  else
    echo "Invalid syntax."
    echo "Usage: cppoi-act <poi-id or poi-list.csv> <source env [dev, stg, prod]> <dest env [dev, stg, prod]>"
  fi
}

cppoi() {
  if [[ "$#" -eq 3 ]]; then
    source ~/dev/venv/venv0/bin/activate
    cd $SPATIAL/argeo/map-builder-pipeline/scripts

    if [[ "$1" == *.csv ]]; then
      if [[ -f "$1" ]]; then
        python -m developer_tools.copy_scan_data --src $2 --dest $3 --poi-list-file $1 --num-viable-scans 400
      else
        echo "POI list file $1 not found."
        return 1
      fi
    else
      python -m developer_tools.copy_scan_data --src $2 --dest $3 --poi-id $1 --num-viable-scans 400
    fi

    back
    reload
  else
    echo "Invalid syntax."
    echo "Usage: cppoi <poi-id or poi-list.csv> <source env [dev, stg, prod]> <dest env [dev, stg, prod]>"
  fi
}

activateWayspot() {
  if [[ "$#" -eq 2 ]]; then
    cd $SPATIAL/argeo/map-builder-pipeline/tools/mapping_utilities
    go build

    if [[ "$1" == *.csv ]]; then
      if [[ -f "$1" ]]; then
        ./mapping_utilities submit-portal-request -e $2 --endpoint '/map_wayspot' --input-list-file $1
      else
        POI list file $1 not found.
        return 1
      fi
    else
      ./mapping_utilities submit-portal-request -e $2 --endpoint '/map_wayspot' --input-ids $1
    fi

    back
  else
    echo "Invalid syntax."
    echo "Usage: activateWayspot <poi-id or poi-list.csv> <env [dev, stg, prod]>"
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
    "-d")
      if [[ "$3" == "" ]];
      then
        echo "Invalid output directory."
        echo "Usage: trainSplats <path/to/prepped/scan> <path/to/output/folder>"
      else
        rm -rf $3 && prepScan ${@:2}
      fi
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