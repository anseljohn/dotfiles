
dkr() {
  case "$1" in
    "list" )
      if [[ $(docker ps -q) ]];
      then
        docker ps -q
      else
        echo "No docker containers running."
      fi
      ;;
    "enter" )
      if [ $# -eq 2 ];
      then
        docker exec -it $2 bash
      else
        err "Invalid arguments."
        echo "Syntax: dkr enter <Container-ID>"
      fi
      ;;
    "start" )
      cd $MONOREPO/argeo/docker-mapping-dev-env
      ./init_cuda_docker_dev_env.sh /home/johnanselmo_nianticlabs_com/dev/niantic /niantic
      back
      ;;
    "build" )
      cd $MONOREPO/argeo/docker-mapping-dev-env
      ./make_cuda_docker_dev_env.sh 
      ;;
    "kill" )
      if [ $# -eq 2 ];
      then
        docker stop $2
      else
        err "Invalid arguments."
        echo "Syntax: dkr kill <Container-ID>"
      fi
      ;;
    * )
      docker $1
  esac
}

