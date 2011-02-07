(import (rnrs)
        (prefix (srfi :13) srfi-13:)
        (mosh)
        (mosh test)
        (mosh ffi)
        (discount)
        (stdio))

(define *pandoc-title* "A Modest Proposal")
(define *pandoc-author* "David Banks")
(define *pandoc-date* "2011-02-07")
(define *pandoc-header*
  (format "% ~a\n% ~a\n% ~a\n" *pandoc-title* *pandoc-author* *pandoc-date*))

(define *style-header* "<style> ul { display: none; } </style>\n")
(define *heading-text* "HEADING")
(define *heading-markup* "\n--------\n")
(define *body* "hello world")
(define *test-string*
  (string-append *style-header*   ; style header must be first, and having one
                                  ; precludes using a pandoc header also.
                 *heading-text*
                 *heading-markup*
                 *body*))
(define *test-size*   (string-length *test-string*))

(define *pandoc-test*
  (string-append *pandoc-header*   ; style header must be first, and having one
                                   ; precludes using a pandoc header also.
                 *heading-text*
                 *heading-markup*
                 *body*))

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
      (mkd-generatetoc mmiot out-stream)
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

(let ((mmiot (mkd-string *pandoc-header*
                         (string-length *pandoc-header*)
                         0)))
  (mkd-compile mmiot 0)
  (let ((title (mkd-doc-title mmiot))
        (date (mkd-doc-date mmiot))
        (author (mkd-doc-author mmiot)))
    (test-equal *pandoc-title* title)
    (test-equal *pandoc-date* date)
    (test-equal *pandoc-author* author)))

(let ((ptr (malloc size-of-pointer)))
  (let ((size (mkd-line *body* (string-length *body*) ptr 0)))
    (let ((real-ptr (pointer-ref-c-pointer ptr 0)))
      (let ((ret (extract-string real-ptr size)))
        (test-true (>= size (string-length *body*)))))))

(let ((out-stream (tmpfile)))
  (test-true   ; makeshift "does not throw exception"
    (begin
      (mkd-generateline *body*
                        (string-length *body*)
                        out-stream
                        0)
      #t)))

(test-results)

