# fzf-apt allows to select apt packages by using fzf and
# builds commands based on the selected packages.
# Copyright (C) 2019  Nico Baeurer

# If we are a root in a Docker container and `sudo` doesn't exist
# lets overwrite it with a function that just executes things passed to sudo
# (yeah it won't work for sudo executed with flags)
if [ -f /.dockerenv ] && ! hash sudo 2>/dev/null && whoami | grep root; then
    sudo() {
        $*
    }
fi


if (( $+commands[sd] )); then
    fapt() {
        packages="$(apt list --verbose 2>/dev/null | \
            # remove "Listing..."
            tail --lines +2 | \
            # place the description on the same line
            # separate the description and the other information
            # with a ^
            sd $'\n {2}([^ ])' $' | $1' | \
            # place the package information and the package description
            # in a table with two columns
            column -t -s "/" | \
            # select packages with fzf
            fzf --multi | \
            # remove everything except the package name
            cut --delimiter '/' --fields 1 | \
            # escape selected packages (to avoid unwanted code execution)
            # and remove line breaks
            xargs --max-args 1 --no-run-if-empty printf "%q ")"

        if [[ -n "${packages}" ]]; then
            print -z "sudo apt ${@}" "${packages}"
        fi
    }
else
    fapt() {
        packages="$(apt list 2>/dev/null | \
            # remove "Listing..."
            tail --lines +2 | \
            # remove everything except the package name
            cut --delimiter '/' --fields 1 | \
            # select packages with fzf
            fzf -m --preview 'apt show {} 2>/dev/null' | \
            # escape selected packages (to avoid unwanted code execution)
            # and remove line breaks
            xargs --max-args 1 --no-run-if-empty printf "%q ")"

        if [[ -n "${packages}" ]]; then
            print -z "sudo apt ${@}" "${packages}"
        fi
    }
fi
