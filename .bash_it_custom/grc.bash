# shellcheck shell=bash disable=SC1090,SC1091,SC2139
# vi: set ft=sh:

# setup grc if the config file exists
if [[ -x "$(command -v grc)" ]]; then
    GRC="$(command -v grc)"
    cmds=(
        as
        blkid
        cc
        configure
        cvs
        df
        diff
        dig
        docker
        docker-machine
        du
        env
        fdisk
        findmnt
        free
        g++
        gas
        gcc
        getsebool
        gmake
        go
        head
        id
        ifconfig
        iostat
        ip
        iptables
        iwconfig
        kubectl
        last
        ld
        ldap
        lsattr
        lsblk
        lsof
        lsmod
        lspci
        make
        mount
        mtr
        netstat
        ping
        ping6
        ps
        sar
        semanage
        stat
        systemctl
        tail
        tcpdump
        traceroute
        traceroute6
        ulimit
        uptime
        vmstat
        wdiff
        whois
    )
    gnu_cmds=(
        stat
    )

    alias colourify="$GRC -es --colour=auto"

    # Set alias for available commands.
    for cmd in "${cmds[@]}"; do
        if [ -x "$(command -v "$cmd" 2>>/dev/null)" ]; then
            alias "$cmd=grc --colour=auto $cmd"
        fi
    done
    for cmd in "${gnu_cmds[@]}"; do
        if [[ -x "g${cmd}" ]] && [[ "$(whence -w "g$cmd")" == *"command"* ]]; then
            alias "$cmd=grc --colour=auto g$cmd"
        fi
    done
fi
