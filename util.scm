#!r6rs

(library (util)
  (export list->alist
          divide-list
          lookup)
  (import (rnrs)
          (srfi :2)
          (prefix (srfi :1) srfi-1:))

  (define (list->alist . args)
    (divide-list 2 args))

  (define (divide-list n lst)
    (cond
     ((null? lst)  '())
     (else
       (let-values (((head tail) (srfi-1:split-at lst n)))
         (cons (apply cons head)
               (divide-list n tail))))))

  (define (lookup key alist)
    (let ((result (assq key alist)))
      (if result
          (cdr result)
          (error 'lookup "key not found in alist" key alist))))

)

