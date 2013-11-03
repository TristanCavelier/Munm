#!/bin/bash
# version 0.1.0 Tue 10 September 2013
# file: /usr/bin/m

#
# The MIT License (MIT)
#
# Copyright (c) 2013 Tristan Cavelier <t.cavelier@free.fr>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

# script using "udisks2", "udisks" or "mount"
# and "lsblk"

# This script shows or mounts devices/partitions
# type m --help for help

cmd="$0"

generate_new_filename() {
    # generate_new_filename basename number ext
    test ! -e "$1_$2$3" && echo "$1_$2$3" && return 0
    generate_new_filename "$1" "$(($2 + 1))" "$3"
}

my_mount() {
    # my_mount /dev/PART
    local mountpoint="$(lsblk -rno LABEL "$1")"
    if [ -z "$mountpoint" ] ; then
        mountpoint=$(lsblk -rno UUID "$1")
    fi
    if [ -e /mnt/"$mountpoint" ] ; then
        mountpoint="$(generate_new_filename "$mountpoint" 1)"
    fi
    mkdir /mnt/"$mountpoint" && mount "$1" /mnt/"$mountpoint" && \
        echo Mounted in /mnt/"$mountpoint"
}

if which udisksctl &>/dev/null ; then
    udisksversion="udisks2"
    mountcmd="udisksctl mount -b"
elif which udisks &>/dev/null ; then
    udisksversion="udisks"
    mountcmd="udisks --mount"
else
    echo WARNING: No udisks program found >&2
    udisksversion="mount"
    mountcmd="my_mount"
fi

usage="Shows/Mounts partitions using \"$udisksversion\" and \"lsblk\".
Usage:   $cmd [options] [sdxy]
Example: $cmd sda3
         $cmd -a

Options list
   -h, --help
          Show this help and exit
   -a, --mount-all
          Mount all partitions.
"

mount_all() {
    local devlist=$(lsblk -nro NAME,TYPE,FSTYPE,MOUNTPOINT | \
        grep -E "^[^ ]+ part [^ ]+ $" | grep -E -v " (swap) " | cut -d ' ' -f 1)
    local result=0
    test ! "$devlist" && return
    echo "$devlist" | while IFS= read -r dev ; do
        $mountcmd "/dev/$dev"
        local res=$?
        test $res -gt $result && result=$res
    done
    return $result
}

mount_selected() {
    local result=0
    for dev in "$@" ; do
        $mountcmd "/dev/$dev"
        local res=$?
        test $res -gt $result && result=$res
    done
    return $result
}

main() {
    local mountall=false
    local getoptret=
    getoptret=$(getopt -ul help,mount-all ha "$@")
    test $? != 0 && echo "$usage" && exit 2
    eval set -- "$getoptret"
    while true ; do
        case "$1" in
            -a|--mount-all)
                mountall=true
                shift
                ;;
            -h|--help)
                exec echo "$usage"
                ;;
            --) shift ; break ;;
            *)  exit 2 ;;
        esac
    done

    if $mountall ; then
        mount_all
    elif test $# = 0 ; then
        lsblk -o NAME,FSTYPE,LABEL,UUID,MOUNTPOINT
        # lsblk -f
    else
        mount_selected "$@"
    fi
}
main "$@"
