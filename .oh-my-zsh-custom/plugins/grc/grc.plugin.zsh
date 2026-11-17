# vi: set ft=zsh:

# setup colorizer
_grc_setup_aliases() {
    add-zsh-hook -d precmd _grc_setup_aliases

    # prioritize gogrc over grc
    local wrapper
    if (( $+commands[gogrc] )); then
        wrapper="gogrc --color=auto"
    elif (( $+commands[grc] )); then
        wrapper="grc --colour=auto"
    else
        return
    fi

    local -a cmds=(
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
    local -a gnu_cmds=(
        stat
    )

    # Set alias for available commands.
    local cmd
    for cmd in ${cmds[@]}; do
        if (( $+commands[$cmd] )) && [[ "$(whence -w $cmd)" == *"command"* ]]; then
            alias $cmd="$wrapper $cmd"
        fi
    done
    for cmd in ${gnu_cmds[@]}; do
        if (( $+commands[g$cmd] )) && [[ "$(whence -w g$cmd)" == *"command"* ]]; then
            alias $cmd="$wrapper g$cmd"
        fi
    done
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _grc_setup_aliases

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
    elif (( $+commands[gogrc] )); then
        builtin ulimit "$@" | gogrc --cat conf.ulimit
        return $pipestatus[1]
    elif (( $+commands[grcat] )); then
        builtin ulimit "$@" | grcat conf.ulimit
        return $pipestatus[1]
    else
        builtin ulimit "$@"
    fi
}
