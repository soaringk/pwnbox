# fuzzy grep open via rg
function vg() {
  local file

  file="$(fd -HI -E .git -E node_modules -E Library | fzf -0 -1 | awk -F: '{print $1}')"

  if [[ -n $file ]]
  then
    vim $file
  fi
}

function cg() {
  local file

  file="$(fd -HI -E .git -E node_modules -E Library | fzf -0 -1 | awk -F: '{print $1}')"

  if [[ -n $file ]]
  then
    code $file
  fi
}


# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
function fkill() {
  local pid
  if [ "$UID" != "0" ]; then
    pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
  else
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  fi

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}


function cd() {
  if [[ "$#" != 0 ]]; then
    builtin cd "$@";
    return
  fi
  while true; do
    local lsd=$(echo ".." && fd -td -d 1 -HI -E '.git')
    local dir="$(printf "${lsd[@]}" |
        fzf --reverse --preview '
            __cd_nxt="$(echo {})";
            __cd_path="$(echo $(pwd)/${__cd_nxt} | sed "s;//;/;")";
            echo $__cd_path;
            echo;
            fd -d 1 -HI -E '.git' -E '.idea' . "${__cd_path}" -x echo {/};
    ')"
    [[ ${#dir} != 0 ]] || return 0
    builtin cd "$dir" &> /dev/null
  done
}

function frm() {
  local file

  file="$(fd -HI -a ${@} -E Library | awk -F: '{print $1}')"

  if [[ -n $file ]]
  then
    rm -r $file
  fi
}

function rga-fzf() {
	RG_PREFIX="rga --files-with-matches"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
	)" &&
	echo "opening $file" &&
	xdg-open "$file"
}
