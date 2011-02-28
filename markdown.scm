#!r6rs

(library (markdown)
  (export divide-list
          list->alist
          options)
  (import (rnrs)
          (util)
          (discount))

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

  (define (options . args)
    (apply bitwise-ior
           (map (lambda (key) (lookup key mapping)) args)))

)
