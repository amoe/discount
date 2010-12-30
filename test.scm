(import (rnrs)
        (mosh test)
        (discount)
        (stdio))

; 
(let ((in-stream (tmpfile))
      (out-stream (tmpfile)))
  (fputs "hello world" in-stream)
  (rewind in-stream)

  (let ((mmiot (mkd-in in-stream 0)))    ; flags = 0
    (test-true mmiot)
    (let ((ret (markdown mmiot out-stream 0)))   ; flags = 0
      (test-equal 0 ret)))

  (for-each fclose (list in-stream out-stream)))

(test-results)
