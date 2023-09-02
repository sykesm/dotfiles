; extends

([
  (interpreted_string_literal)
  (raw_string_literal)
 ] @contents @nospell
(#lua-match? @contents "%a+://[%a%d/]+")) ; contains a URL?
