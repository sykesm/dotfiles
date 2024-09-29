; extends

; ----------------------------------------------------------------
; a genqlient graph query

([
   (interpreted_string_literal)
   (raw_string_literal)
 ] @injection.content
 (#contains? @injection.content "@genqlient")
 (#offset! @injection.content 0 1 0 -1)
 (#set! injection.language "graphql"))

; ----------------------------------------------------------------
; probably json

((raw_string_literal) @injection.content
 (#match? @injection.content "^`(\\\{|\\\[)")
 (#offset! @injection.content 0 1 0 -1)
 (#set! injection.language "json"))

; ----------------------------------------------------------------
; probably yaml

((raw_string_literal) @injection.content
 (#match? @injection.content "^`---\n")
 (#offset! @injection.content 0 1 0 -1)
 (#set! injection.language "yaml"))
