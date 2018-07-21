#!/bin/bash
# include this script in your project
# or copy following lines in your own script

# {{{ BASE LOG, DISPLAY & EXIT FUNCTIONS

# {{{ colors variables declaration
export    _esc="\033[0m"     # Text Reset
export  _black="\033[01;30m" # Black
export    _red="\033[01;31m" # Red
export  _green="\033[01;32m" # Green
export _yellow="\033[01;33m" # Yellow
export   _blue="\033[01;34m" # Blue
export _purple="\033[01;35m" # Purple
export   _cyan="\033[01;36m" # Cyan
export  _white="\033[01;37m" # White
export  _white_on_red="\033[1;37;41m"
# }}}

# {{{ function log
#
log() {
    local ls_args=""
    while [ "x${1:0:1}" == "x-" ] ; do
        ls_args="$ls_args $1" ; shift
    done
    echo $ls_args "[`date "+%F %T"`]: $@"
}
export -f log
# }}}

# {{{ function color_and_prefix
#
color_and_prefix() {
    local ls_args="-e"
    local color="$1" ; shift
    while [ "x${1:0:1}" == "x-" ] ; do
        ls_args="$ls_args $1" ; shift
    done
    local prefix="`echo ${FUNCNAME[1]} | tr [[:lower:]] [[:upper:]]`"
    log $ls_args "${!color}$prefix : $@${_esc}"
}
export -f color_and_prefix
# }}}

# {{{ function success
#
success() {
    color_and_prefix _white $@
}
export -f success
# }}}

# {{{ function error
#
error() {
    color_and_prefix _white_on_red $@
}
export -f error
# }}}

# {{{ function warning
#
warning() {
    color_and_prefix _yellow $@
}
export -f warning
# }}}

# {{{ function info
#
info() {
    color_and_prefix _cyan $@
}
export -f info
# }}}

# {{{ function quit
#
quit() {
    error "${FUNCNAME[1]}: $@"
    exit 1
}
export -f quit
# }}}

# {{{ function yes_no
#
yes_no() {
    local mess="$1"
    local resp
    while true ; do
        echo "$mess (y/n) ?"
        read resp
        case $resp in
            [yY]|[yY][eE][sS]) return 0 ;;
            [nN]|[nN][oO]) return 1 ;;
            *) "'$resp' : bad resp ! please answer with 'yes' or 'no' ('y' or 'n')." ;;
        esac
    done
}
export -f yes_no
# }}}

# }}}
