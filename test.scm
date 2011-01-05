(import (rnrs)
        (mosh test)
        (mosh ffi)
        (discount)
        (stdio))

(define *style-header* "<style> ul { display: none; } </style>\n")
(define *body* "hello world")
(define *test-string* (string-append *style-header* *body*))
(define *test-size*   (string-length *test-string*))

(let ((in-stream (tmpfile))
      (out-stream (tmpfile)))
  (fputs *test-string* in-stream)
  (rewind in-stream)

  (let ((mmiot (mkd-in in-stream 0)))    ; flags = 0
    (test-true mmiot)
    (let ((ret (markdown mmiot out-stream 0)))   ; flags = 0
      (test-equal 0 ret)))

  (for-each fclose (list in-stream out-stream)))

(let ((out-stream (tmpfile))
      (test-size (string-length *test-string*)))
  (let ((mmiot (mkd-string *test-string* test-size 0)))
    (test-true mmiot)
    (let ((ret (markdown mmiot out-stream 0)))
      (test-equal 0 ret)))

  (fclose out-stream))

(let ((out-stream (tmpfile))
      (test-size (string-length *test-string*)))
  (let ((mmiot (mkd-string *test-string* test-size 0)))
    (test-true mmiot)
    (let ((ret (mkd-compile mmiot 0)))
      (test-equal 0 ret))))    ; This test will always fail due to a bug in
                               ; discount (or the docs).

(define (extract-string ptr size)
  (list->string
   (let loop ((n 0))
     (if (>= n size)
         '()
         (cons (integer->char (pointer-ref-c-signed-char ptr n))
               (loop (+ n 1)))))))

(let ((mmiot (mkd-string *test-string* *test-size* 0)))
  (mkd-compile mmiot 0)
  (let ((ptr (malloc size-of-pointer)))
    (let ((size (mkd-css mmiot ptr)))
      (let ((real-ptr (pointer-ref-c-pointer ptr 0)))
        (test-equal *style-header* (extract-string real-ptr size))))))

        
(let ((mmiot (mkd-string *test-string* *test-size* 0))
      (out-stream (tmpfile)))
  (mkd-compile mmiot 0)
  (test-false   ; makeshift "does not throw exception"
    (begin
      (mkd-generatecss mmiot out-stream)
      #f)))

(test-results)
