; extends

;; Common database query methods
(method_invocation
  name: (identifier) @method_name
  (#any-of? @method_name
   ; Core JDBC
   "executeQuery" "executeUpdate" "prepareCall" "prepareStatement"
   ; JPA / EntityManager
   "createNativeQuery" "createNamedNativeQuery"
   ; Spring JdbcTemplate
   "batchUpdate" "query" "queryForList" "queryForMap" "queryForObject"
   ; Spring Boot JdbcClient / DatabaseClient
   "sql")
  arguments: (argument_list
    (string_literal
      [(string_fragment) (multiline_string_fragment)] @injection.content))
  (#set! injection.language "sql"))

;; Triggers if the variable name contains 'sql' or 'query' (case-insensitive)
(variable_declarator
  name: (identifier) @variable_name
  (#match? @variable_name "\\v\\c(sql|query)")
  value: (string_literal
    [(string_fragment) (multiline_string_fragment)] @injection.content)
  (#set! injection.language "sql"))

;; JDBI annotations
(annotation
  name: (identifier) @annotation_name
  (#any-of? @annotation_name "SqlQuery" "SqlUpdate" "SqlBatch" "SqlScript")
  arguments: (annotation_argument_list
    [
      ; Matches direct string values: @SqlQuery("...")
      (string_literal
        [(string_fragment) (multiline_string_fragment)] @injection.content)

      ; Matches named parameter pairs: @SqlQuery(value = "...")
      (element_value_pair
        value: (string_literal
          [(string_fragment) (multiline_string_fragment)] @injection.content))
    ])
  (#set! injection.language "sql"))
