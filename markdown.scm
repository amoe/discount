#!r6rs

(library (markdown)
  (export markdown)
  (import (rnrs)
          (prefix (discount) discount:)
          (xitomatl keywords)
          (mosh ffi))

  (define/kw (markdown source
                       (format :default 'html)
                       (stream :default #t)
                       (properties :default (list)))
    (let ((mmiot (discount:mkd-string source (string-length source) 0))
          (result (malloc size-of-pointer)))
      (discount:mkd-compile mmiot 0)
      (let* ((size (discount:mkd-document mmiot result))
             (real-ptr (pointer-ref-c-pointer result 0))
             (str-result (extract-string real-ptr size)))
        (free result)
        (values mmiot str-result))))
        
  ; FIXME: Optimize.
  (define (extract-string ptr size)
    (list->string
     (let loop ((n 0))
       (if (>= n size)
           '()
           (cons (integer->char (pointer-ref-c-signed-char ptr n))
                 (loop (+ n 1)))))))
)
