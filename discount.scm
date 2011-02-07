#!r6rs

(library (discount)
  (export mkd-in
          markdown
          mkd-string
          mkd-compile
          mkd-css
          mkd-generatecss
          mkd-document
          mkd-generatehtml
          mkd-xhtmlpage
          mkd-toc
          mkd-generatetoc
          mkd-cleanup
          mkd-doc-title
          mkd-doc-author
          mkd-doc-date
          mkd-line
          mkd-generateline

          ; preprocessor constants
          *nolinks*
          *noimage*
          *nopants*
          *nohtml*
          *strict*
          *tagtext*
          *no_ext*
          *cdata*
          *nosuperscript*
          *norelaxed*
          *notables*
          *nostrikethrough*
          *toc*
          *1_compat*
          *autolink*
          *safelink*
          *noheader*
          *tabstop*
          *nodivquote*
          *noalphalist*
          *nodlist*
          *embed*)
  (import (rnrs)
          (mosh ffi))

; FIXME: filename should be determined by libtool / configure.ac
(define lib (open-shared-library "libmarkdown.so"))

; top-level functions from markdown(3)
(define mkd-in (c-function lib void* mkd_in void* int))
(define mkd-string (c-function lib void* mkd_string char* int int))
(define markdown (c-function lib int markdown void* void* int))

; miscellaneous functions from mkd-functions(3)
(define mkd-compile (c-function lib int mkd_compile void* int))
(define mkd-css (c-function lib int mkd_css void* void*))
(define mkd-generatecss (c-function lib int mkd_generatecss void* void*))
(define mkd-document (c-function lib int mkd_document void* void*))
(define mkd-generatehtml (c-function lib int mkd_generatehtml void* void*))
(define mkd-xhtmlpage (c-function lib int mkd_xhtmlpage void* int void*))
(define mkd-toc (c-function lib int mkd_toc void* void*))
(define mkd-generatetoc (c-function lib int mkd_generatetoc void* void*))
(define mkd-cleanup (c-function lib void mkd_cleanup void*))
(define mkd-doc-title (c-function lib char* mkd_doc_title void*))
(define mkd-doc-author (c-function lib char* mkd_doc_author void*))
(define mkd-doc-date (c-function lib char* mkd_doc_date void*))

; line based functions from mkd-line(3)
(define mkd-line (c-function lib int mkd_line char* int void* int))
(define mkd-generateline
  (c-function lib int mkd_generateline char* int void* int))

(define *nolinks* 1)
(define *noimage* 2)
(define *nopants* 4)
(define *nohtml* 8)
(define *strict* 16)
(define *tagtext* 32)
(define *no_ext* 64)
(define *cdata* 128)
(define *nosuperscript* 256)
(define *norelaxed* 512)
(define *notables* 1024)
(define *nostrikethrough* 2048)
(define *toc* 4096)
(define *1_compat* 8192)
(define *autolink* 16384)
(define *safelink* 32768)
(define *noheader* 65536)
(define *tabstop* 131072)
(define *nodivquote* 262144)
(define *noalphalist* 524288)
(define *nodlist* 1048576)
(define *embed* 35)

)
 
