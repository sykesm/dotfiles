# vi: set ft=zsh:

# setup grc if the config file exists
if (( $+commands[grc] )); then
    # Commands
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

    # Set alias for available commands.
    for cmd in ${cmds[@]}; do
        if (( $+commands[$cmd] )) && [[ "$(whence -w $cmd)" == *"command"* ]]; then
            alias $cmd="grc --colour=auto $cmd"
        fi
    done
    for cmd in ${gnu_cmds[@]}; do
        if (( $+commands[g$cmd] )) && [[ "$(whence -w g$cmd)" == *"command"* ]]; then
            alias $cmd="grc --colour=auto g$cmd"
        fi
    done

    # Clean up variables
    unset cmds cmd gnu_cmds
fi
