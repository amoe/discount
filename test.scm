(import (rnrs)
        (mosh test)
        (discount)
        (stdio))

(define *test-string* "hello world")

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
      (test-equal 0 ret))))

(test-results)
