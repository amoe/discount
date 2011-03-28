#!r6rs

(library (markdown)
  (export markdown)
  (import (rnrs)
          (prefix (discount) discount:)
          (xitomatl keywords))

  (define/kw (markdown source
                       (format :default 'html)
                       (stream :default #t)
                       (properties :default (list)))
    (values 'stub:document-object
            'stub:render-value)))
