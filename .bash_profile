# .bash_profile
# shellcheck shell=bash disable=SC1090,SC1091,SC2046

# Attempt to work around the Apple path_helper behavior by preventing
# environment propagation to login shells.
if [ -x /usr/libexec/path_helper ]; then
    eval $(PATH="" /usr/libexec/path_helper -s)
fi

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
unset USERNAME
