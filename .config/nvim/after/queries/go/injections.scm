; extends

; ----------------------------------------------------------------
; a genqlient graph query

([
   (interpreted_string_literal)
   (raw_string_literal)
 ] @graphql
 (#contains? @graphql "@genqlient")
 (#offset! @graphql 0 1 0 -1))

; ----------------------------------------------------------------
; probably json

((raw_string_literal) @json
 (#match? @json "^`(\\\{|\\\[)")
 (#offset! @json 0 1 0 -1))

; ----------------------------------------------------------------
; probably yaml

((raw_string_literal) @yaml
 (#match? @yaml "^`---\n")
 (#offset! @yaml 0 1 0 -1))
