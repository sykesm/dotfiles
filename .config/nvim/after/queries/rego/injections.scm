; extends

; ----------------------------------------------------------------
; a genqlient graph query

([
   (raw_string)
 ] @injection.content
 (#contains? @injection.content "query ")
 (#offset! @injection.content 0 1 0 -1)
 (#set! injection.language "graphql"))
