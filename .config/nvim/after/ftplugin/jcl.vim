setlocal colorcolumn=72
setlocal foldexpr=v:lua.require'sykesm.jcl'.foldexpr()
setlocal foldmethod=expr
setlocal foldtext=
setlocal iskeyword+=$,#,@-@
setlocal nowrap

lua require('sykesm.jcl').keymaps(0)
