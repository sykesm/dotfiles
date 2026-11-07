setlocal colorcolumn=72
setlocal foldexpr=v:lua.require'sykesm.jcl'.foldexpr()
setlocal foldlevel=1
setlocal foldmethod=expr
setlocal iskeyword+=$,#,@-@
setlocal nowrap

lua require('sykesm.jcl').keymaps(0)
