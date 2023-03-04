# .zprofile

# Attempt to work around the Apple path_helper behavior by preventing
# environment propagation to login shells.
if [ -x /usr/libexec/path_helper ]; then
    eval $(PATH="" MANPATH="" /usr/libexec/path_helper -s)
fi
