# Munm

Fast bash scripts to mount and/or unmount devices (no GUI).

Version v0.2.0

Tested on Ubuntu, Debian and ArchLinux.

## Usage

    {m|um|d} \[sdxy ...\]

### Example

Show disks and partitions:

    $ m

Mount /dev/sdb1 and /dev/sdb2 on /run/media/USER (*udisks2*) or /media (*udisks*):

    $ m sdb1 sdb2

Unmount then:

    $ um sdb1 sdb2

Detach (power-off) a disk:

    $ d sdb

If *udisks* or *udisks2* are not installed, use this program with `sudo`:

    $ sudo m sdb1 sdb2

## Dependencies

- `lsblk`
- `udisksctl` (*udisks2*), `udisks` or `mount`

## Install

System wide:

    install -m 755 /path/to/{m,um,d} /usr/bin  # or '/usr/local/bin'

User only:

    mkdir -p $HOME/bin
    install -m 755 /path/to/{m,um,d} $HOME/bin
    if ! echo "$PATH" | grep -E '(^|:)'$HOME'/bin(:|$)' &>/dev/null ; then
        echo 'PATH="$HOME/bin:$PATH"' >> $HOME/.bashrc
    fi

## License

> Copyright (c) 2014 Tristan Cavelier <t.cavelier@free.fr>
>
> This program is free software. It comes without any warranty, to
> the extent permitted by applicable law. You can redistribute it
> and/or modify it under the terms of the Do What The Fuck You Want
> To Public License, Version 2, as published by Sam Hocevar. See
> the COPYING file for more details.
