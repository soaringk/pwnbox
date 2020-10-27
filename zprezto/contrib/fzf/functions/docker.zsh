# Select a docker container to start, attach, stop or remove
function da() {
    local cid
    cid=$(docker ps -a | sed 1d | fzf -m -1 -q "$1" | awk '{print $1}')

    if [ -n "$cid" ]; then
        read "input?(a)ttach, (s)top, (r)emove container $(echo $cid | tr '\n' ' '): "
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

# select a docker container to execute
function de() {
    local cid
    cid=$(docker ps | sed 1d | fzf -1 | awk '{print $1}')

    if [ -n "$cid" ]; then
        print -z "docker exec -it ${cid}" "${@}"
    fi
}

# Select a docker image to remove
function drmi() {
  local cid=$(docker image ls | sed 1d | fzf -m -q "$1")
  local name=$(echo $cid | awk '{print $1":"$2}')
  local hash_id=$(echo $cid | awk '{print $3}')

  [ -n "$cid" ] && echo $name | xargs docker rmi || echo $hash_id | xargs docker rmi
}

# Select a docker image to run
function dr() {
  local cid
  cid=$(docker image ls | sed 1d | fzf -q "$1" | awk '{print $1":"$2}')

  [ -n "$cid" ] && print -z -- "docker run --rm -it $cid"
}
