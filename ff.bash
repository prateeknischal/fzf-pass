#!/usr/bin/env bash

set -e
readonly VERSION="0.0.1"

# The PREFIX variable is exported by pass which contains the root directory for
# where the passwords are stored.
DEFAULT_PASS_DIRECTORY="$PREFIX"
PASS_OPT_COPY="--clip"

_command_fzf_version() {
    cat <<- _EOF
    $PROGRAM $COMMAND $VERSION - A pass(1) extension that provides fuzzy
        search on the password list using fzf(1)
_EOF
}

_open_link() {
    if [[ "$OSTYPE" =~ "linux" ]]; then
        xdg-open "$1"
    elif [[ "$OSTYPE" =~ "darwin" ]]; then
        open "$1"
    else
        echo "Please visit $1 for more details";
    fi
}

_find_fzf() {
    if ! command -v fzf >/dev/null; then
        echo "'fzf' not found, please install fzf first"
        echo "More details on https://github.com/junegunn/fzf#installation"
        _open_link "https://github.com/junegunn/fzf#installation"
        exit 1
    fi
}

_call_fzf() {
    if [ $# -gt 0 ]; then
        hint=$1; shift;
        match=$(cd $DEFAULT_PASS_DIRECTORY && fzf -e -1 -q "$hint")
    else
        match=$(cd $DEFAULT_PASS_DIRECTORY && fzf -e -1)
    fi
    echo "$match"
}

_convert_file_to_pass_format() {
    filename="$1"; shift;

    if [ ! -e "$DEFAULT_PASS_DIRECTORY/$filename" ]; then
        echo "file '$DEFAULT_PASS_DIRECTORY/$filename' not found"
        exit 1
    fi

    passname=${filename%.gpg};
    echo $passname
}

find_password() {
    if ! _find_fzf; then
        exit 1
    fi

    filename=$(_call_fzf "$1");
    passname=$(_convert_file_to_pass_format "$filename");
    if [ ! -n "$passname" ]; then
        echo "password not found"
        exit 1
    fi

    if [ ! -n "$PASS_OPT_COPY" ]; then
        echo "Getting password for $passname"
        pass "$passname" 2>/dev/null
    else
        pass --clip "$passname" 2>/dev/null
    fi
}

_print_version() {
    pass --version
    _command_fzf_version
}

_print_usage() {
    _command_fzf_version
    echo
    cat <<- _EOF
    Usage:
    $PROGRAM ff [-h] [-n] [pass-name]
        Provide the capability of fuzzy search from the password list
        using fzf(1).

    Options:
        -n, --no-copy   Print the password instead of writing to clipboard
        -v, --version   Print the version and exit
        -h, --help      Print this help message and exit
_EOF
}

main() {
    # opt parsing taken from https://github.com/roddhjav/pass-update
    small_arg="hvc"
    long_arg="help,version,no-copy"
    opts="$($GETOPT -o $small_arg -l $long_arg -n "$PROGRAM $COMMAND" -- "$@")"
    err=$?
    eval set -- "$opts"

    while true; do case $1 in
    -h|--help)
        _print_usage;
        exit 0;
    ;;

    -v|--version)
        _print_version;
        exit 0;
    ;;

    -n|--no-copy)
        PASS_OPT_COPY="";
        shift 1;
    ;;

    --) shift;
        break
    ;;

    esac done

    find_password "$@"
}

main "$@"

