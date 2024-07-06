# tmux-256color

macOS (as of Big Sur) still does not have the compiled terminfo for
tmux-256color. In order to make things work, we have to compile the terminfo.

A copy of the definition is in this folder and can be installed by running

```
/usr/bin/tic -x tmux-256color
```
