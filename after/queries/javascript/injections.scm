;; extends


; the following structures will inject html syntax into the template_string
; object.html(`....`), object.append(`...`), object.prepend(`....`) $(`...`)
(call_expression
  function: [
    (member_expression
      property: (property_identifier) @_prop
      (#any-of? @_prop "html" "append" "prepend"))
    (identifier) @func_name
    (#any-of? @func_name "$")
  ]
  arguments: (
    arguments (template_string) @injection.content
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.include-children)
    (#set! injection.language "html")
  )
)
