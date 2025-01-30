; extends

; ----------------------------------------------------------------
; a genqlient graph query

([
   (interpreted_string_literal_content)
   (raw_string_literal_content)
 ] @injection.content
 (#contains? @injection.content "@genqlient")
 (#set! injection.language "graphql"))

; ----------------------------------------------------------------
; probably json

((raw_string_literal_content) @injection.content
 (#match? @injection.content "^[\n|\t| ]*(\\\{|\\\[)")
 (#set! injection.language "json"))

; ----------------------------------------------------------------
; probably yaml

((raw_string_literal_content) @injection.content
 (#match? @injection.content "^[\n|\t| ]*---\n")
 (#set! injection.language "yaml"))
