dk() {
  case "$1" in
    "list" )

      case $2 in
        "")
          docker ps -a
          ;;
        "-a")
          if [[ $(docker ps -q) ]];
          then
            docker ps -q
            return 0
          else
            echo "No docker containers running."
            return 1
          fi
          ;;
        *)
          err "Invalid arguments."
          echo "Syntax: dr list [-a]"
          ;;
      esac
      ;;
    "enter" )
      if [ $# -eq 2 ];
      then
        if [[ $(docker ps -q) == *"$2"* ]];
        then
          echo "Entering container #$2..."
          docker exec -lt $2 zsh
        else
          echo "Container #$2 is not running. Attemping to start..."
          dk start $2 
          dk enter $2
        fi
      else
        err "Invalid arguments."
        echo "Syntax: dr enter <Container-ID>"
      fi
      ;;
    "start" )
      case "$2" in
        "-r" )
          dk stop all
          dk start
          ;;
        "rebuild")
          dk build
          dk start
          ;;
        "cuda")
          cd $MONOREPO/argeo/docker-mapping-dev-env
          ./init_cuda_docker_dev_env.sh /home/johnanselmo_nianticlabs_com/dev/niantic ~/dev/niantic
          back
          ;;
        "")
          docker run --gpus all --name massf -it tesp:main
          ;;
        *)
          docker start $2
      esac
      ;;
    "build" )
      cd $MONOREPO/argeo/docker-mapping-dev-env
      ./make_cuda_docker_dev_env.sh $2
      ;;
    "stop" )
      if [ $# -eq 2 ];
      then
        echo "Stopping:"
        if [[ "$2" == "all" ]];
        then
          docker stop $(dk list) 
        else
          docker stop $2
        fi
      else
        err "Invalid arguments."
        echo "Syntax: dr stop [container-id | all]"
      fi
      ;;
    "kill" )
      if [ $# -eq 2 ];
      then
        echo "Killing:"
        if [[ "$2" == "all" ]];
        then
          docker kill $(dk list)
        else
          docker kill $2
        fi
      else
        err "Invalid arguments."
        echo "Syntax: dr kill [container-id | all]"
      fi
      ;;
    "cp" )
      if [[ $# -eq 3 ]];
      then
        docker cp $2 $3
      else
        err "Invalid arguments."
        echo "Syntax:"
        echo "\tCopy to container: dr cp /local/file.txt container_id:/cont_file.txt"
        echo "\tCopy from container: dr cp container_id:/cont_file.txt /local/file.txt"
      fi
      ;;
    "help" )
      echo "\ndk - docker alias"
      echo "------------------"
      echo "Syntax:\n"
      echo "dk <options>\n\n"
      echo "Options:"
      echo "-------\n"
      echo "list"
      echo "\tList all running containers.\n"
      echo "cp </local/file> <container_id>:</container/file>"
      echo "\tCopies the local file to the container. Swap arguments to copy to local.\n"
      echo "enter <Container-ID>"
      echo "\tEnter a container.\n"
      echo "start"
      echo "\tMounts a docker to $MONOREPO and enters is.\n"
      echo "build (-f)"
      echo "\tRuns the docker-mapping-dev-env make cuda docker script."
      echo "\t\t-f : forces base and interactive build.\n"
      echo "stop [container-id | all]"
      echo "\t Stops the container.\n"
      echo  "kill [container-id | all]"
      echo "\t Kills the container."

      ;;
    * )
      docker $1
  esac
}

