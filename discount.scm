#!r6rs

(import (rnrs)
        (mosh ffi)
        (ffi-streams))

(define (say obj)
  (display obj)
  (newline))

(let* ((lib (open-shared-library "libmarkdown.so"))
       (mkd-in (c-function lib void* mkd_in void* int))
       (markdown (c-function lib int markdown void* void* int)))
  (let* ((in-stream (fopen "/home/amoe/test.txt" "r"))
         (out-stream (fopen "/home/amoe/test.html" "w"))
         (mmiot (mkd-in in-stream 0)))
    (markdown mmiot out-stream 0)
    (fclose in-stream)
    (fclose out-stream)))
