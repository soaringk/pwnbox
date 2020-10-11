# Install (one or multiple) selected application(s)
# using "brew search" as source input
# mnemonic [B]rew [I]nstall [P]lugin
function bip() {
  local inst=$(brew search | fzf -m --preview 'brew info {}')

  if [[ $inst ]]; then
    for token in $(echo $inst); do
      brew install $token
    done
  fi
}

# Delete (one or multiple) selected application(s)
# mnemonic [B]rew [C]lean [P]lugin (e.g. uninstall)
function bxp() {
  local uninst=$(brew leaves | fzf -m --preview 'brew info {}')

  if [[ $uninst ]]; then
    for token in $(echo $uninst); do
      brew uninstall $token
    done
  fi
}

# Install or open the webpage for the selected application
# using brew cask search as input source
# and display a info quickview window for the currently marked application
function bcip() {
  local inst=$(brew search --casks | fzf -m --preview 'brew cask info {}')

  if [ $inst ]; then
    read "input?(i)nstall or open the (h)omepage of $token: "
    if [ $input = "i" ] || [ $input = "I" ]; then
      for token in $(echo $inst); do
        brew cask install $token
      done
    elif [ $input = "h" ] || [ $input = "H" ]; then
      for token in $(echo $inst); do
        brew home $token
      done
    fi
  fi
}

# Uninstall or open the webpage for the selected application
# using brew list as input source (all brew cask installed applications)
# and display a info quickview window for the currently marked application
function bcxp() {
  local uninst=$(brew cask list | fzf -m --preview 'brew cask info {}')

  if [ $uninst ]; then
    for token in $(echo $uninst); do
      brew cask uninstall $token
    done
  fi
}

