#!r6rs

(library (stdio)
  (export fopen
          fclose)
  (import (rnrs) (mosh ffi))

  (define lib (open-shared-library "libc.so.6"))    ; FIXME: nonportable

  (define fopen  (c-function lib void* fopen char* char*))
  (define fclose (c-function lib int fclose void*)))
