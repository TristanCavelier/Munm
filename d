#!/bin/bash

# Version: v0.1.0

# Copyright (c) 2014 Tristan Cavelier <t.cavelier@free.fr>
# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# the COPYING file for more details.

cmd=$(basename "$0")
usage="Usage: $cmd [sdx...]"

use_udisks_detach() {
    udisks --detach "$1"
}

use_udisks2_detach() {
    udisksctl power-off -b "$1"
}

main () {
    [ $# = 0 ] && echo "$usage" && exec lsblk -f

    local d=
    local res=0

    # set detach command
    if which udisksctl &>/dev/null ; then d=use_udisks2_detach
    elif which udisks &>/dev/null ; then d=use_udisks_detach
    else echo "No detach command found" >&2 ; return 2 ; fi

    # detach
    for i in "$@" ; do
        $d /dev/"$i" || res=$?
    done

    return $res
}

main "$@"
