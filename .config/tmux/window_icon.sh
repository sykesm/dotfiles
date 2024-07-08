#!/bin/bash
# shellcheck disable=SC2034

icon_Python=''
icon_apt=''
icon_bash=''
icon_beam=''
icon_beam_smp=''
icon_brew=''
icon_caffeinate=''
icon_cargo=''
icon_cfdisk=''
icon_csh=''
icon_dnf=''
icon_docker=''
icon_dpkg=''
icon_emacs=''
icon_fdisk=''
icon_fish=''
icon_git=''
icon_gitui=''
icon_go=''
icon_htop=''
icon_htop=''
icon_java=''
icon_kubectl='󱃾'
icon_lazydocker=''
icon_lazygit=''
icon_lf=''
icon_lfcd=''
icon_lvim=''
icon_nala=''
icon_node=''
icon_nvim=''
icon_pacman=''
icon_parted=''
icon_paru=''
icon_python=''
icon_ranger=''
icon_ruby=''
icon_rustc=''
icon_rustup=''
icon_sh=''
icon_tcsh=''
icon_tig=''
icon_tmux=''
icon_top=''
icon_topgrade='󰚰'
icon_vim=''
icon_yay=''
icon_yum=''
icon_zsh=''

key="icon_${1//./_}"
value="${!key}"

if [[ -n "$value" ]]; then
    echo -n "$value $1"
else
    echo "$1"
fi
