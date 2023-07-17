; extends

; ----------------------------------------------------------------
; a genqlient graph query

([
   (interpreted_string_literal)
   (raw_string_literal)
 ] @graphql
 (#contains? @graphql "@genqlient")
 (#offset! @graphql 0 1 0 -1))
