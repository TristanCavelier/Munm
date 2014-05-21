#!/bin/bash

# Version: v0.2.0

# Copyright (c) 2014 Tristan Cavelier <t.cavelier@free.fr>
# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# the COPYING file for more details.

cmd=$(basename "$0")
usage="Usage: $cmd [sdxx...]"

newname() {
    [ -e "$1" ] && newname "$1-" && return 0
    echo "$1"
}

blkget() {
    local tmp=
    tmp=$(lsblk -rno "$1" "$2" | head -n 1) || return 2
    [ "$tmp" ] && echo "$tmp"
}

use_mount_mount() {
    local id=
    id=$(blkget LABEL "$1") || return 1
    [ ! "$id" ] && id=$(blkget UUID "$1")
    mkdir -p /run/munm
    id=$(newname "/run/munm/$id") || return 255
    mkdir "$id" || return 1
    mount "$1" "$id"
}

use_udisks_mount() {
    udisks --mount "$1"
}

use_udisks2_mount() {
    udisksctl mount -b "$1"
}

main () {
    [ $# = 0 ] && echo "$usage" && exec lsblk -f

    local m=
    local res=0

    # set mount command
    if which udisksctl &>/dev/null ; then m=use_udisks2_mount
    elif which udisks &>/dev/null ; then m=use_udisks_mount
    elif which mount &>/dev/null ; then m=use_mount_mount
    else echo "No mount command found" >&2 ; return 2 ; fi

    # mount
    for i in "$@" ; do
        $m /dev/"$i" || res=$?
    done

    return $res
}

main "$@"
