#!r6rs

(library (stdio)
  (export fopen
          fclose
          tmpfile
          rewind
          fputs
          printf)
  (import (rnrs) (mosh ffi))

  (define lib (open-shared-library "libc.so.6"))    ; FIXME: nonportable

  (define fopen  (c-function lib void* fopen char* char*))
  (define fclose (c-function lib int fclose void*))
  (define tmpfile (c-function lib void* tmpfile))
  (define rewind (c-function lib void rewind void*))
  (define fputs (c-function lib int fputs char* void*))
  (define printf (c-function lib int printf char* void*)))
