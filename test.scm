(import (rnrs)
        (prefix (srfi :13) srfi-13:)
        (mosh)
        (mosh test)
        (mosh ffi)
        (discount)
        (stdio))

(define *style-header* "<style> ul { display: none; } </style>\n")
(define *heading-text* "HEADING")
(define *heading-markup* "\n--------\n")
(define *body* "hello world")
(define *test-string*
  (string-append *style-header*
                 *heading-text*
                 *heading-markup*
                 *body*))
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

; This plus mkd-generatehtml test below should do more validation on what ends
; up being written to output stream.  At the very least we should count the
; length of what was written to out-stream and make sure it's reasonably sized.
       
(let ((mmiot (mkd-string *test-string* *test-size* 0))
      (out-stream (tmpfile)))
  (mkd-compile mmiot 0)
  (test-true   ; makeshift "does not throw exception"
    (begin
      (mkd-generatecss mmiot out-stream)
      #t)))

(let ((mmiot (mkd-string *test-string* *test-size* 0)))
  (mkd-compile mmiot 0)
  (let ((ptr (malloc size-of-pointer)))
    (let ((size (mkd-document mmiot ptr)))
      (let ((real-ptr (pointer-ref-c-pointer ptr 0)))
        (let ((ret (extract-string real-ptr size)))
          (test-true (srfi-13:string-contains ret *body*))
          (test-true (>= size (string-length *body*))))))))

(let ((mmiot (mkd-string *test-string* *test-size* 0))
      (out-stream (tmpfile)))
  (mkd-compile mmiot 0)
  (test-true   ; makeshift "does not throw exception"
    (begin
      (mkd-generatehtml mmiot out-stream)
      #t)))

(let ((mmiot (mkd-string *test-string* *test-size* 0))
      (out-stream (tmpfile)))
  (mkd-compile mmiot 0)
  (test-true   ; makeshift "does not throw exception"
    (begin
      (mkd-xhtmlpage mmiot 0 out-stream)
      #t)))

(let ((mmiot (mkd-string *test-string* *test-size* 0)))
  (mkd-compile mmiot *toc*)
  (let ((ptr (malloc size-of-pointer)))
    (let ((size (mkd-toc mmiot ptr)))
      (let ((real-ptr (pointer-ref-c-pointer ptr 0)))
        (let ((ret (extract-string real-ptr size)))
          (test-true (srfi-13:string-contains ret *heading-text*))
          (test-true (>= size (string-length *heading-text*))))))))

(let ((mmiot (mkd-string *test-string* *test-size* 0))
      (out-stream (tmpfile)))
  (mkd-compile mmiot *toc*)
  (test-true   ; makeshift "does not throw exception"
    (begin
      (mkd-generatetoc mmiot  out-stream)
      #t)))

; Can't make any tests on the return value of mkd_cleanup(), as it returns
; #<unspecified> and we can't compare two of these values.
(let ((mmiot (mkd-string *test-string* *test-size* 0))
      (out-stream (tmpfile)))
  (mkd-compile mmiot 0)
  (test-true
   (begin
     (mkd-cleanup mmiot)
     #t)))

(test-results)
