(import (rnrs)
        (mosh test)
        (discount)
        (stdio))

(let ((stream (tmpfile)))
  (rewind stream)
  (test-true stream))
(test-results)
