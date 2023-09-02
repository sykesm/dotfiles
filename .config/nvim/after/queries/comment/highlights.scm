; extends

;; disable spell check for bare nolint
("text" @nolint @nospell
 (#eq? @nolint "nolint"))

;; disable spell check for nolint:linter
("text" @nolint @nospell . "text" @symbol @nospell . "text" @issue @nospell
 (#eq? @nolint "nolint")
 (#eq? @symbol ":")
 (#lua-match? @issue "^[%a%d]+$"))
