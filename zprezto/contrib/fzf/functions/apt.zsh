# fzf-apt allows to select apt packages by using fzf and
# builds commands based on the selected packages.
# Copyright (C) 2019  Nico Baeurer
function insert_stdin {
    # if this wouldn't be an external script
    # we could use 'print -z' in zsh to edit the line buffer
    stty -echo
    perl -e 'ioctl(STDIN, 0x5412, $_) for split "", join " ", @ARGV;' \
        "$@"
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    packages="$(apt list --verbose 2>/dev/null | \
        # remove "Listing..."
        tail --lines +2 | \
        # place the description on the same line
        # separate the description and the other information
        # with a ^
        sd $'\n {2}([^ ])' $'^$1' | \
        # place the package information and the package description
        # in a table with two columns
        column -t -s^ | \
        # select packages with fzf
        fzf --multi | \
        # remove everything except the package name
        cut --delimiter '/' --fields 1 | \
        # escape selected packages (to avoid unwanted code execution)
        # and remove line breaks
        xargs --max-args 1 --no-run-if-empty printf "%q ")"

    if [[ -n "${packages}" ]]; then
        insert_stdin "# apt ${@}" "${packages}"
    fi
fi
