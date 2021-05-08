# tmux-256color

macOS (as of Big Sur) still does not have the compiled terminfo for
tmux-256color. In order to make things work, we have to compile the terminfo.

A copy of the definition is in this folder and can be installed by running

```
/usr/bin/tic -x tmux-256color
```

The original source of the file is

```
https://gist.githubusercontent.com/nicm/ea9cf3c93f22e0246ec858122d9abea1/raw/37ae29fc86e88b48dbc8a674478ad3e7a009f357/tmux-256color
```
