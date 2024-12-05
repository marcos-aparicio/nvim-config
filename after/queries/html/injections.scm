;;extends

  (attribute
    (attribute_name) @name
    (#match? @name "x-data|x-show|x-init|x-bind:.*|x-text|x-for|x-on:.*|x-model|x-ref")
    (quoted_attribute_value
      (attribute_value) @injection.content (#set! injection.language "javascript")
      )
  )
 @all
