#
# Fuzzy file finder module for prezto
#

# if not exists fzf
if (( !$+commands[fzf] )); then
  return 1
fi


if zstyle -t ':prezto:module:fzf' key-bindings; then
  source "$HOME/.fzf/shell/key-bindings.zsh"
  export FZF_DEFAULT_OPTS='--no-height --reverse'
fi

if zstyle -t ':prezto:module:fzf' completion; then
  [[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.zsh" 2> /dev/null
fi

# Set height of fzf results
zstyle -s ':prezto:module:fzf' height FZF_HEIGHT

# Open fzf in a tmux pane if using tmux
if zstyle -t ':prezto:module:fzf' tmux && [ -n "$TMUX_PANE" ]; then
  export FZF_TMUX=1
  export FZF_TMUX_HEIGHT=${FZF_HEIGHT:-40%}
  alias fzf="fzf-tmux -d${FZF_TMUX_HEIGHT}"
else
  export FZF_TMUX=0
  if [ ! -z "$FZF_HEIGHT" ]; then
    export FZF_DEFAULT_OPTS="--height ${FZF_HEIGHT} --reverse"
  fi
fi

__fzf_prog() {
  [ -n "$TMUX_PANE" ] && [ "${FZF_TMUX:-0}" != 0 ] && [ ${LINES:-40} -gt 15 ] &&
    echo "fzf-tmux -d${FZF_TMUX_HEIGHT}" || echo "fzf"
}


# Use fd or ripgrep or ag if available
if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND="fd -HI -E .git -E node_modules -E Library"
  _fzf_compgen_path() {
    fd -H -E .git -E node_modules "$1"
  }
elif (( $+commands[rg] )); then
  export FZF_DEFAULT_COMMAND="rg --files --hidden -g '!{.git,node_modules,Library}' 2> /dev/null"
  _fzf_compgen_path() {
    rg --files --hidden -g '!{.git,node_modules,Library}/*' "$1" 2>/dev/null
  }
fi



# Uncomment to use --inline-info option
# export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --inline-info"


# Set colors defined by user
if zstyle -t ':prezto:module:fzf' colorscheme; then
  source "${0:h}/colors.zsh"
  zstyle -s ':prezto:module:fzf' colorscheme FZF_COLOR
  if [[ ! -z "$FZF_COLOR" && ${fzf_colors["$FZF_COLOR"]} ]]; then
    export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --color ${fzf_colors["$FZF_COLOR"]}"
  fi
fi


export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# Use preview window with Ctrl-T
export FZF_CTRL_T_OPTS="--select-1 --exit-0 --preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -a -I Library -C {}) 2> /dev/null | head -200'"


# Full command on preview window
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

# Directly executing the command
fzf-history-widget-accept() {
  fzf-history-widget
  zle accept-line
}
zle     -N     fzf-history-widget-accept
bindkey '^X^R' fzf-history-widget-accept


# If tree command is installed, show directory contents in preview pane when
# using ALT-C
if (( $+commands[tree] )); then
  export FZF_ALT_C_OPTS="--select-1 --exit-0 --preview 'tree -a -I Library -C {} | head -200'"
fi


# load extra fzf function
if zstyle -t ':prezto:module:fzf' extra; then
  for file in "${0:h}"/functions/*; do
    source "$file"
  done
fi
