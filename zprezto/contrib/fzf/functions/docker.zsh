# Select a docker container to start, attach, stop or remove
function dc() {
    local cid
    cid=$(docker ps -a | sed 1d | fzf -m -1 -q "$1" | awk '{print $1}')

    if [ -n "$cid" ]; then
        read "input?(a)ttach, (s)top, (r)emove container\n$cid: "
        case "$input" in
            [Aa]* )  
                docker start "$cid" && docker attach "$cid"
                ;;
            [Ss]* )  
                echo $cid | xargs docker stop "$cid"
                ;;
            [Rr]* )  
                echo $cid | xargs docker stop "$cid" && xargs docker rm "$cid"
                ;;
            * ) echo "Invalid input!"
                ;;
        esac
    fi
}

# Select a docker image to remove
function drmi() {
  local cid
  cid=$(docker image ls | sed 1d | fzf -m -q "$1" | awk '{print $1":"$2}')

  [ -n "$cid" ] && echo $cid | xargs docker rmi
}

# Select a docker image to run
function dr() {
  local cid
  cid=$(docker image ls | sed 1d | fzf -q "$1" | awk '{print $3}')

  [ -n "$cid" ] && echo $cid && docker run --rm -it "$cid"
}
