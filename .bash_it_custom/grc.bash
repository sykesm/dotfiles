# shellcheck shell=bash disable=SC1090,SC1091,SC2139
# vi: set ft=sh:

# configure colorizer, prioritizing gogrc over grc
if [[ -x "$(command -v gogrc)" ]]; then
    GRC_WRAPPER="gogrc --color=auto"
elif [[ -x "$(command -v grc)" ]]; then
    GRC_WRAPPER="grc --colour=auto"
fi

if [[ -n "${GRC_WRAPPER:-}" ]]; then
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
        uptime
        vmstat
        wdiff
        whois
    )
    gnu_cmds=(
        stat
    )

    alias colourify="$GRC_WRAPPER -es"

    # Set alias for available commands.
    for cmd in "${cmds[@]}"; do
        if [ -x "$(command -v "$cmd" 2>>/dev/null)" ]; then
            alias "$cmd=$GRC_WRAPPER $cmd"
        fi
    done
    for cmd in "${gnu_cmds[@]}"; do
        if [[ "$(type -t "g$cmd")" == "file" ]]; then
            alias "$cmd=$GRC_WRAPPER g$cmd"
        fi
    done
    unset cmds gnu_cmds cmd
fi
unset GRC_WRAPPER

# ulimit is a shell builtin, so it can't be aliased like the commands above:
# a wrapper would set limits in a child process. Instead, color the output of
# queries such as "ulimit -a" and run the builtin directly to set a limit.
ulimit() {
    local arg
    for arg in "$@"; do
        if [[ $arg != -* ]]; then
            builtin ulimit "$@"
            return
        fi
    done
    if [[ ! -t 1 ]]; then
        builtin ulimit "$@"
    elif [[ -x "$(command -v gogrc)" ]]; then
        builtin ulimit "$@" | gogrc --cat conf.ulimit
        return "${PIPESTATUS[0]}"
    elif [[ -x "$(command -v grcat)" ]]; then
        builtin ulimit "$@" | grcat conf.ulimit
        return "${PIPESTATUS[0]}"
    else
        builtin ulimit "$@"
    fi
}
