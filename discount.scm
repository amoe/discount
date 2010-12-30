#!r6rs

(library (discount)
  (export mkd-in)
  (import (rnrs)
          (mosh ffi))

; FIXME: filename should be determined by libtool / configure.ac
(define lib (open-shared-library "libmarkdown.so"))

(define mkd-in (c-function lib void* mkd_in void* int))

)
