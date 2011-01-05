#!r6rs

(library (discount)
  (export mkd-in
          markdown
          mkd-string
          mkd-compile
          mkd-css)
  (import (rnrs)
          (mosh ffi))

; FIXME: filename should be determined by libtool / configure.ac
(define lib (open-shared-library "libmarkdown.so"))

(define mkd-in (c-function lib void* mkd_in void* int))
(define mkd-string (c-function lib void* mkd_string char* int int))
(define markdown (c-function lib int markdown void* void* int))
(define mkd-compile (c-function lib int mkd_compile void* int))
(define mkd-css (c-function lib int mkd_css void* void*))

)
 
