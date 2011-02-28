#!r6rs

(library (markdown)
  (export divide-list
          list->alist
          process
          options)
  (import (rnrs)
          (util)
          (discount)
          (mosh ffi))

  (define mapping
    (list->alist
     'no-links *nolinks*
     'no-images *noimage*
     'no-smartypants *nopants*
     'no-html  *nohtml*
     'strict   *strict*
     'process-tag-text *tagtext*
     'no-pseudo-protocols *no_ext*
     'cdata    *cdata*
     'no-superscript *nosuperscript*
     'emphasize-all *norelaxed*
     'no-tables *notables*
     'no-strikethrough   *nostrikethrough*
     'process-toc   *toc*
     'version-1-compat *1_compat*
     'auto-link *autolink*
     'safe-link *safelink*
     'no-headers *noheader*
     'tab-stop-4 *tabstop*
     'no-class-blocks *nodivquote*
     'no-alphabetic-lists *noalphalist*
     'no-definition-lists *nodlist*))

  ; FIXME: Optimize.
  (define (extract-string ptr size)
    (list->string
     (let loop ((n 0))
       (if (>= n size)
           '()
           (cons (integer->char (pointer-ref-c-signed-char ptr n))
                 (loop (+ n 1)))))))

  (define (options . args)
    (apply bitwise-ior
           (map (lambda (key) (lookup key mapping)) args)))

  (define (process input . opt-list)
    (let* ((flags (apply options opt-list))
           (mmiot (mkd-string input
                              (string-length input)
                              flags)))
      (mkd-compile mmiot flags)   ; FIXME: check return code
      (let* ((text-ptr (malloc size-of-pointer))
             (size (mkd-document mmiot text-ptr))
             (real-ptr (pointer-ref-c-pointer text-ptr 0)))
        (extract-string real-ptr size))))
)
