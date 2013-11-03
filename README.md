# Munm

Fast bash scripts to mount and/or unmount devices (no GUI).

## Usage

Without parameters, `m` and `um` show partitions using `lsblk`.

    {m|um} \[options\] \[sdxy \[sdxy \[...\]\]\]

Common option:

- `-h,--help` Show usage and exit

`m` options:

- `-a,--mount-all` Mount all partitions

`um` options:

- `-a,--unmount-all` Unmount all partitions

### Example

Show disks and partitions:

    $ m
    $ m # `sudo m` might print more informations

Mount /dev/sdb1 and /dev/sdb2 on /run/media/USER (*udisks2*) or /media (*udisks*):

    $ m sdb1 sdb2

Unmount all:

    $ um -a

If *udisks* is not installed, use this program with `sudo`:

    $ sudo m sdb1 sdb2
    $ sudo um -a

## Dependencies

- `lsblk`
- `udisksctl` (*udisks2*), `udisks` or `mount`

Tested on Ubuntu, Debian and ArchLinux.

## Install

System wide:

    cp /path/to/{m,um} -t /usr/bin
    chmod +x /usr/bin/{m,um}

User only:

    cd
    mkdir -p bin
    cp /path/to/{m,um} -t bin
    echo 'PATH=$HOME/bin:$PATH' >> .bashrc
